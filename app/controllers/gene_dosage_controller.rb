class GeneDosageController < ApplicationController

  def index
    @assertions = GeneDosageAssertion.all.limit(100)
  end

end
