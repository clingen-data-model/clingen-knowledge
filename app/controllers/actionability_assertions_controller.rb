class ActionabilityAssertionsController < ApplicationController

  def index
    @page = params[:page] || 1
    @assertions = ActionabilityAssertion.all.with_associations(:genes, :diseases, :intervention_assertions).page(@page).per(20)
  end

end
