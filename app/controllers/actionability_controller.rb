class ActionabilityController < ApplicationController

  def index
    @assertions = ActionabilityAssertion.all.limit(200)
  end

end
