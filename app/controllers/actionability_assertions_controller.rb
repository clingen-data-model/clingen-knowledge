class ActionabilityAssertionsController < ApplicationController

  def index
    @page = params[:page] || 1
    @assertions = ActionabilityAssertion.all.with_associations(:genes, :diseases, :intervention_assertions).page(@page).per(20)
  end

  def show
    @actionability = ActionabilityAssertion.find_by(perm_id: params[:id])
  	redirect_to @actionability.file
  end

end
