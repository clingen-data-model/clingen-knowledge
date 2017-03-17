class ActionabilityAssertionsController < ApplicationController

  def index
  	@pageTitle = "Clinical Actionability Curations";
    @page = params[:page] || 1
    # @assertions = ActionabilityAssertion.all.with_associations(:genes, :diseases, :intervention_assertions).page(@page).per(20)
    @assertions = helpers.index_list(@page)


    @analyticsDimension7  = "KB Actionability Curations - Listing"
  end

  def show
    @actionability = ActionabilityAssertion.find_by(perm_id: params[:id])
  	redirect_to @actionability.file
  end

end
