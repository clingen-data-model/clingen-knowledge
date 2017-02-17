class DashboardController < ApplicationController
	
	def index
		@agent = current_agent
  end

end