class GeneDiseaseAssertionsController < ApplicationController

  def index
    @assertions = GeneDiseaseAssertion.all.limit(200)
    respond_to do |format|
      format.html
    end
  end
  
  def show
    @assertion = GeneDiseaseAssertion.find_by(perm_id: params[:id])
    @assertionScoreJson = ActiveSupport::JSON.decode(@assertion.score_string)
    #@assertionScoreArray = JSON.parse(assertionScoreJson)
  end
  
end
