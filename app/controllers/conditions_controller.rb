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

  def show
    expires_in 10.minutes, public: true
    
    @condition = Condition.find_by(curie: params[:id])

    # unless @condition.assertions.exists?
    #   redirect_to condition_external_resources_conditions_path(@condition) 
    # end

    @term_label = truncate(@condition.label, :length => 50, :omission => '...')
    @term_id = @condition.curie
    @term_curie = @condition.curie
    @dosage = @condition.assertions(:a).with_associations(:interpretation, :genes)
                .where("a:GeneDosageAssertion")
    @genes = @condition.as(:c).assertions.genes(:g).where("((c)<-[:has_related_phenotype]-(g) or not (g)-[:has_related_phenotype]->(:DiseaseConcept))").distinct
    @actionability  = @condition.actionability_scores
    @validity = @condition.assertions(:n).with_associations(:interpretation, :genes)
                  .where("n:GeneDiseaseAssertion")
    @validity_detail = @validity.reduce({}) do |h, i|
      h.update(i.genes.reduce({}) { |h1, i1| h1.update({i1.uuid => i}) })
    end
    @dosage_detail = @dosage.reduce({}) do |h, i|
      h.update(i.genes.reduce({}) { |h1, i1| h1.update({i1.uuid => i}) })
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
