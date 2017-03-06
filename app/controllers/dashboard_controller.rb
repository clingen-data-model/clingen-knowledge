class DashboardController < ApplicationController
  
  def index
    @agent = current_agent
    @notes = @agent.notes(:n).where("n.deleted is null")
  end

end
