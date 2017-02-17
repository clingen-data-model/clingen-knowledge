class GeneValidityController < ApplicationController

  def index
    @assertions = GeneDiseaseAssertion.all.limit(200)
  end
  
end
