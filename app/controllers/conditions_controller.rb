class ConditionsController < ApplicationController
  include ActionView::Helpers::TextHelper

  def index
    expires_in 10.minutes, public: true

    @pageTitle = "Conditions";
    @page = params[:page] || 1
    if params[:term]
      @conditions = Condition.find_by_term(params[:term]).page(@page).per(20)
    elsif params[:curated]
      @conditions = Condition.all(:c).where("(c)<-[:has_object]-(:Assertion)")
                      .with_associations(:assertions)
                      .page(@page)
                      .per(20)
    else
      @conditions = Condition.page(@page).per(20)
    end
    respond_to do |format|
      format.json { render json: @conditions, root: false }
      format.html
    end


    @analyticsDimension7  = "KB Conditions - Index"
  end

  ConditionQuery = ClingenKnowledge::Client.parse <<-'GRAPHQL'
  query($iri: String!) {
    condition(iri: $iri) {
      label
      gene {
        label
        hgnc_id
      }
      actionability_curations {
        report_date
        source
      }       
      genetic_conditions {
        gene {
          label
          hgnc_id
        }
        actionability_curations {
          report_date
          source
        }       
      }
    }
  }
  GRAPHQL

  def show
    expires_in 10.minutes, public: true
    
    @condition = RDFClass.find_by(curie: params[:id])

    unless @condition.labels.include?(:DiseaseConcept)
      c = @condition.equivalent_terms(:c).where("c :DiseaseConcept").first
      redirect_to c, status: 301
    else

	  @gql_result = ClingenKnowledge::Client.query(ConditionQuery, variables: {iri: @condition.iri})

      @term_label = truncate(@condition.label, :length => 50, :omission => '...')
      @term_id = @condition.curie
      @term_curie = @condition.curie
      @dosage = @condition.assertions(:a).with_associations(:interpretation, :genes)
                  .where("a:GeneDosageAssertion")
      @genes = @condition.as(:c).assertions.genes(:g).where("((c)<-[:has_related_phenotype]-(g) or (c)<-[:has_object]-(:GeneDiseaseAssertion) or not (g)-[:has_related_phenotype]->(:DiseaseConcept))").distinct
      @actionability  = @condition.actionability_scores
      @validity = @condition.assertions(:n).with_associations(:interpretation, :genes)
                    .where("n:GeneDiseaseAssertion")
      @validity_detail = @validity.reduce({}) do |h, i|
        h.update(i.genes.reduce({}) { |h1, i1| h1.update({i1.uuid => i}) })
      end
      @dosage_detail = @dosage.reduce({}) do |h, i|
        h.update(i.genes.reduce({}) { |h1, i1| h1.update({i1.uuid => i}) })
      end

	# The results from GQL are not really formatted consistent with the other
    # searches.  Rather than pollute the views with a lot of code, we'll just
    # refactor it into something similar for consistency and easier changes.
    #
    # Hash table has one entry per gene, and each entry has list of conditions
    # sorted by adult/ped for direct access by views.
    @gql_actionability = Hash.new
	if !@gql_result.data.condition.gene.blank?
		@gql_actionability[@gql_result.data.condition.gene.label] = Hash.new	
		if !@gql_result.data.condition.actionability_curations.blank?
			@gql_result.data.condition.actionability_curations.each_with_index do |ac, aindex|
			
				# remove this if we can pull doc from database
				doc = ac.source.scan(/doc=([^"]+)/)[0][0]
				next if doc == nil
				
				# group together the reports for easier displaying
				if @gql_actionability[@gql_result.data.condition.gene.label].key?(doc) == false
					@gql_actionability[@gql_result.data.condition.gene.label][doc] = []
				end
				if ac.source.include? "Pediatric"
					adult = "PEDIATRIC"
				elsif ac.source.include? "Adult"
					adult = "ADULT"
				else
					adult = "Unknown"
				end
				# end adult/ped check
				@gql_actionability[@gql_result.data.condition.gene.label][doc] << Actionabilityql.new(@gql_result.data.condition.gene.label, @gql_result.data.condition.gene.label, ac.report_date, ac.source, adult, doc)
			end
		end
	end
	# Since basically the same results can be returned as an actionability_curation
	# or under genetic conditions, we duplicate the above.  Since this is all temporary
	# and will likely be replaced in a few months, we just to a quick and dirty copy.
	if !@gql_result.data.condition.genetic_conditions.blank?
		@gql_result.data.condition.genetic_conditions.each_with_index do |gc, gindex|
		
			if !gc.actionability_curations.blank?
				@gql_actionability[gc.gene.label] = Hash.new
				gc.actionability_curations.each_with_index do |gac, gaindex|
		
					# remove this if we can pull doc from database
					doc = gac.source.scan(/doc=([^"]+)/)[0][0]
					next if doc == nil
			
					# group together the reports for easier displaying
					if @gql_actionability[gc.gene.label].key?(doc) == false
						@gql_actionability[gc.gene.label][doc] = []
					end
					if gac.source.include? "Pediatric"
						adult = "PEDIATRIC"
					elsif gac.source.include? "Adult"
						adult = "ADULT"
					else
						adult = "Unknown"
					end
					# end adult/ped check
					@gql_actionability[gc.gene.label][doc] << Actionabilityql.new(gc.gene.label, gc.gene.label, gac.report_date, gac.source, adult, doc)
				end
			end
		end
	end
		
      @pageTitle = @term_label;

      @analyticsDimension7  = "KB Conditions - Show"
      if @genes || @actionability || @validity 
        @analyticsDimension2  = @condition.label
      else
        @analyticsDimension4  = @condition.label
      end
    end
  end
end
