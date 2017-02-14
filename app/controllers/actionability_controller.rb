class ActionabilityController < ApplicationController

  def index
    @assertions = ActionabilityAssertion.all.limit(1)
  end

end
