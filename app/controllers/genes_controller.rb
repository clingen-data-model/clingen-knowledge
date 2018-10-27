class GenesController < ApplicationController
  include ActionView::Helpers::TextHelper


  def index
    expires_in 10.minutes, public: true

    respond_to do |format|
      format.json do
        @genes = Gene.all(:g).where("g.symbol starts with {symbol}")
                   .params(symbol: params[:term]).limit(10)
        render json: @genes, root: false
      end
      format.html do
        @page = params[:page] || 1

        if params[:term]
          @genes = Gene.find_by_term(params[:term])
                     .with_associations(:assertions)
                     .page(@page)
                     .per(20)
        elsif params[:curated]
          @genes = Gene.all(:g)
                     .where("(g)<-[:has_subject]-(:Assertion)")
                     .with_associations(:assertions)
                     .page(@page)
                     .per(20)
        else
          @genes = Gene.all.with_associations(:assertions).page(@page).per(20)
        end
      end
    end
    @pageTitle = "Genes"

    @analyticsDimension7  = "KB Genes - Index"
  end

  # Be sure to add here anything needed for the gene_facts partial
  def show
    expires_in 10.minutes, public: true

    @gene = Gene.find_by(hgnc_id: params[:id])

    # @term_label = truncate(@gene.symbol, :length => 20, :omission => '...')
    # @term_id = truncate(@gene.hgnc_id)
    @diseases = @gene.as(:g).assertions.diseases(:d).where("((d)<-[:has_related_phenotype]-(g) or (d)<-[:has_object]-(:GeneDiseaseAssertion) or not (g)-[:has_related_phenotype]->())").distinct
    @concepts = @diseases.equivalent_terms(:t).where("t :DiseaseConcept")
    @curations = @gene.query_as(:g)
                   .return("g {.symbol,
	gene_validity_interps: [(g)<-[:has_subject]-(gv:GeneDiseaseAssertion) | gv {.date,
    	condition: [(gv)-[:has_object|:equivalentClass*..2]->(c:DiseaseConcept) | c {.label, .iri}][0],
    	significance: [(gv)-[:has_predicate]->(i:Interpretation) | i {.label, .iri}][0],
        replaced_by: [(gv)<-[:wasInvalidatedBy]-(r) | r.iri ]}],
    gene_dosage_interps: [(g)<-[:has_subject]-(gd:GeneDosageAssertion) | gd {.date,
    	condition: [(gd)-[:has_object|:equivalentClass*..2]->(c:DiseaseConcept) | c {.label, .iri}][0],
        significance: [(gd)-[:has_predicate]->(i:Interpretation) | i {.label, .iri}]}][0],
    actionability_interps: [(g)<-[:has_subject]-(a:ActionabilityAssertion) | a {.date,
    	condition: [(a)-[:has_object|:equivalentClass*..2]->(c:DiseaseConcept) | c {.label, .iri}][0]}]}")
                   .to_a


    @actionability = @gene.actionability_scores
    
    if @actionability.length > 0
      @actionability_diseases = @actionability.map {|a| a[:disease]}.flatten
    end
    @dosage = @gene.assertions(:a).with_associations(:interpretation, :diseases)
                .where("a:GeneDosageAssertion")
    @validity = @gene.assertions(:n)
                  .with_associations(:interpretation, :diseases)
                  .where("n:GeneDiseaseAssertion")
                  .where("NOT((n)-[:wasInvalidatedBy]->())")
    @diseases_detail = @validity.reduce({}) do |h, i|
      h.update(i.diseases.reduce({}) { |h1, i1| h1.update({i1.iri => i}) })
    end
    @dosage_detail = @dosage.reduce({}) do |h, i|
      h.update(i.diseases.reduce({}) { |h1, i1| h1.update({i1.iri => i}) })
    end

    @pageTitle = @term_label;

    @analyticsDimension7  = "KB Genes - Show"

    if @genes || @actionability || @validity
      @analyticsDimension1  = @gene.symbol
    else
      @analyticsDimension3  = @gene.symbol
    end

  end

end
