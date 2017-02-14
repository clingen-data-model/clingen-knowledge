class GeneValidityController < ApplicationController

  def index
    @assertions = GeneDiseaseAssertion.all.limit(3)
  end
  
end
