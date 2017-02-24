class GeneValidityController < ApplicationController

  def index
    @assertions = GeneDiseaseAssertion.all.limit(200)
  end
  
  def show
    @assertion = GeneDiseaseAssertion.find(params[:id])
  end
  
end
