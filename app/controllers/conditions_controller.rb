class ConditionsController < ApplicationController
  include ActionView::Helpers::TextHelper

  def index
    if params[:term]
      @conditions = Condition.all(:c).where("c.label contains {term}")
                      .params(term: params[:term]).limit(10)
    else
      @conditions = Condition.all.limit(10)
    end
    respond_to do |format|
      format.json { render json: @conditions, root: false }
      format.html
    end
  end

  def show
    @condition = Condition.find_by(curie: params[:id])
    @term_label = truncate(@condition.label, :length => 20, :omission => '...')
    @term_id = @condition.curie
    @term_curie = @condition.curie.gsub! '_', ':'

    @genes = @condition.assertions.genes.distinct
    @actionability  = @condition.actionability_scores
    @validity = @condition.assertions(:n).with_associations(:interpretation, :genes)
                  .where("n:GeneDiseaseAssertion")
    @validity_detail = @validity.reduce({}) do |h, i|
      h.update(i.genes.reduce({}) { |h1, i1| h1.update({i1.uuid => i}) })
    end
    
  end

end
