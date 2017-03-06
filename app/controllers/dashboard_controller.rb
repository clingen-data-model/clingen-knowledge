class DashboardController < ApplicationController
  
  def index
    @agent = current_agent
    @notes = @agent.notes(deleted: nil)
  end

end
