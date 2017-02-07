class DashboardController < ApplicationController
	
	def index
		@agents = Agent.all 
  end

end