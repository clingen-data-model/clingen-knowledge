class ActionabilityController < ApplicationController

  def index
    @assertions = ActionabilityAssertion.all.limit(20)
  end

end
