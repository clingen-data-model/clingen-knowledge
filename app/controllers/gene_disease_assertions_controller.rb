class GeneDiseaseAssertionsController < ApplicationController

  def index
    expires_in 4.hours, public: true

    # @assertions = GeneDiseaseAssertion.all.limit(200)
    @assertions = Gene.all(:g).assertions(:a).where('a :GeneDiseaseAssertion').order('g.symbol').pluck(:a)
    respond_to do |format|
      format.html
    end
    @pageTitle = "Gene Validity Curations"

    @analyticsDimension7  = "KB Gene Validity - Index"
  end
  
  def show
    expires_in 4.hours, public: true

    @assertion = GeneDiseaseAssertion.find_by(perm_id: params[:id])
    @assertionScoreJson = ActiveSupport::JSON.decode(@assertion.score_string)
    @assertionScoreJsonPretty = JSON.pretty_generate(@assertionScoreJson)
    #@assertionScoreArray = JSON.parse(assertionScoreJson)

    @pageTitle = "Gene Validity Curation"

    @analyticsDimension7  = "KB Gene Validity - Show"
  end
  
end
