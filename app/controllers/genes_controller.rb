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
    @term_label = truncate(@gene.symbol, :length => 20, :omission => '...')
    @term_id = truncate(@gene.hgnc_id)
    @diseases = @gene.assertions.diseases.distinct
    @actionability = @gene.actionability_scores
    
    @curated_match = Gene.query_as(:Gene)
                       .where("Gene.symbol = {gene_symbol}")
                       .match("(Gene)<-[r:has_subject]-(assertion)-[rr:has_object]->(condition)")
                       .return("Gene {.symbol,
                                conditionGroups: collect(distinct {
                    conditionGroup: [(condition)-[:equivalentTo]-(equivTo) | equivTo.curie ] + condition.curie
                  })
                } as rows")
                       .params(gene_symbol: @gene.symbol)
                       .to_a.map()

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
