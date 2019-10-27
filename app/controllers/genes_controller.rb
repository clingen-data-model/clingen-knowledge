class Actionabilityql
 
    include ActiveModel::Model
    attr_accessor :iri, :label, :report_date, :source, :adult, :doc
    
    def initialize(iri, label, report_date, source, adult, doc)
		@iri = iri
		@label = label
		@report_date = report_date
		@source = source
		@doc = doc
		@adult = adult
	end
 
end


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

  GeneQuery = ClingenKnowledge::Client.parse <<-'GRAPHQL'
  query($iri: String!) {
    gene(iri: $iri) {
      label
      conditions {
        iri
        label
        actionability_curations {
          report_date
          source
        }
      }     
    }
  }
  GRAPHQL

  # Be sure to add here anything needed for the gene_facts partial
  def show
    expires_in 10.minutes, public: true
    
    @gql_result = ClingenKnowledge::Client.query(GeneQuery, variables: {iri: params[:id]})
    
    @gene = Gene.find_by(hgnc_id: params[:id])
    
    # @term_label = truncate(@gene.symbol, :length => 20, :omission => '...')
    # @term_id = truncate(@gene.hgnc_id)
    @diseases = @gene.as(:g).assertions.diseases(:d).where("((d)<-[:has_related_phenotype]-(g) or (d)<-[:has_object]-(:GeneDiseaseAssertion)-[:has_subject]->(g) or not (g)-[:has_related_phenotype]->())").distinct
    @concepts = @diseases.equivalent_terms(:t).where("t :DiseaseConcept")
    @curations = @gene.query_as(:g).return("g {.symbol,
	gene_validity_interps: [(g)<-[:has_subject]-(gv:GeneDiseaseAssertion) | gv {.date,
    	condition: [(gv)-[:has_object|:equivalentClass*..2]->(c:DiseaseConcept) | c {.label, .iri}][0],
    	significance: [(gv)-[:has_predicate]->(i:Interpretation) | i {.label, .iri}][0],
        replaced_by: [(gv)<-[:wasInvalidatedBy]-(r) | r.iri ]}],
    gene_dosage_interps: [(g)<-[:has_subject]-(gd:GeneDosageAssertion) | gd {.date,
    	condition: [(gd)-[:has_object|:equivalentClass*..2]->(c:DiseaseConcept) | c {.label, .iri}][0],
        significance: [(gd)-[:has_predicate]->(i:Interpretation) | i {.label, .iri}]}][0],
    actionability_interps: [(g)<-[:has_subject]-(a:ActionabilityAssertion) | a {.date,
    	condition: [(a)-[:has_object|:equivalentClass*..2]->(c:DiseaseConcept) | c {.label, .iri}][0]}]}").to_a


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
    
    
    # The results from GQL are not really formatted consistent with the other
    # searches.  Rather than pollute the views with a lot of code, we'll just
    # refactor it into something similar for consistency and easier changes.
    #
    # Hash table has one entry per gene, and each entry has list of conditions
    # sorted by adult/ped for direct access by views.
    @gql_actionability = Hash.new
    if !@gql_result.data.gene.conditions.blank?
		@gql_result.data.gene.conditions.each_with_index do |c, index|
			if c.actionability_curations.length > 0
				if @gql_actionability.key?(c.iri) == false
					@gql_actionability[c.iri] = Hash.new
				end
				c.actionability_curations.each_with_index do |ac, aindex|
				
					# remove this if we can pull doc from database
					doc = ac.source.scan(/doc=([^"]+)/)[0][0]
					next if doc == nil
					
					# group together the reports for easier displaying
					if @gql_actionability[c.iri].key?(doc) == false
						@gql_actionability[c.iri][doc] = []
					end
					if ac.source.include? "Pediatric"
						adult = "PEDIATRIC"
					elsif ac.source.include? "Adult"
						adult = "ADULT"
					else
						adult = "Unknown"
					end
					# end adult/ped check
					@gql_actionability[c.iri][doc] << Actionabilityql.new(c.iri, c.label, ac.report_date, ac.source, adult, doc)
				end
			end
		end
    end
    
    @pageTitle = @gene.symbol;

    @analyticsDimension7  = "KB Genes - Show"

    if @genes || @actionability || @validity
      @analyticsDimension1  = @gene.symbol
    else
      @analyticsDimension3  = @gene.symbol
    end

  end

end
