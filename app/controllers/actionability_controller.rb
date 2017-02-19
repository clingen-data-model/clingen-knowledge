class ActionabilityController < ApplicationController

  def index
    @assertions = ActionabilityAssertion.all.with_associations(:genes, :diseases, :intervention_assertions).limit(200)
  end

end
