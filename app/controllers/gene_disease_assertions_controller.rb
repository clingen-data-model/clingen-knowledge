class GeneDiseaseAssertionsController < ApplicationController

  def index
    # @assertions = GeneDiseaseAssertion.all.limit(200)
    @assertions = Gene.all(:g).assertions(:a).where('a :GeneDiseaseAssertion').order('g.symbol').pluck(:a)
    respond_to do |format|
      format.html
    end
    @pageTitle = "Gene Validity Curations"
  end
  
  def show
    @assertion = GeneDiseaseAssertion.find_by(perm_id: params[:id])
    @assertionScoreJson = ActiveSupport::JSON.decode(@assertion.score_string)
    @assertionScoreJsonPretty = JSON.pretty_generate(@assertionScoreJson)
    #@assertionScoreArray = JSON.parse(assertionScoreJson)

    @pageTitle = "Gene Validity Curation"
  end
  
end
