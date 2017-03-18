class ApplicationController < ActionController::Base
#   protect_from_forgery with: :exception


  
  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :authenticate_user!, except: [:home, :about, :contact]

 	protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :institution, :title, :degrees, :opt_out, :subscriptions_all_curations, :clingen_newsletter])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :institution, :title, :degrees, :opt_out, :subscriptions_all_curations, :clingen_newsletter])
  end

  def after_sign_in_path_for(agent)
	  dashboard_index_path
	end
	def after_update_path_for(agent)
	  dashboard_index_path
	end
	
	def after_sign_out_path_for(agent)
	  agent_session_path
	end
	
end
