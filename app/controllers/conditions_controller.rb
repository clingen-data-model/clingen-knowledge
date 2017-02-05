class ConditionsController < ApplicationController

  def index
  	  	@conditions = Condition.limit(10)
  end

  def show
  end

end
