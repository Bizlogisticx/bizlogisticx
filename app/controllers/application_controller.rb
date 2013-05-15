class ApplicationController < ActionController::Base
	protect_from_forgery
  	
  	protected
	helper_method :admin?
	
	def authorize
		unless admin?
			flash[:error] = 'Unauthorized login!'
			redirect_to homes_path
			false
		else
			true
		end
	end
	def admin?
		@user = User.find_by_email(session[:email])
		if session[:user_id]
			@user.admin
		end
	end
end
