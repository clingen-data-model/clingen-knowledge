class DashboardController < ApplicationController
	
	def index
		@agents = Agent.all 
		@hello_message = "Welcome to JRuby on Rails on the Sun GlassFish Enterprise Server"
  end

end