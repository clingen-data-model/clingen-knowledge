class ConditionsController < ApplicationController

  def index
    @conditions = Condition.all.limit(10)
  end

  def show
    @condition = Condition.find_by(curie: params[:id])
    @genes = @condition.assertions.genes.distinct
    @actionability  = @condition.actionability_scores
    @validity = @condition.assertions(:n).with_associations(:interpretation, :genes)
                  .where("n:GeneDiseaseAssertion")
    @validity_detail = @validity.reduce({}) do |h, i|
      h.update(i.genes.reduce({}) { |h1, i1| h1.update({i1.uuid => i}) })
    end
  end

end
