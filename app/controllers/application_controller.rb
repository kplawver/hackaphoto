class ApplicationController < ActionController::Base
  protect_from_forgery
	before_filter :require_user
	layout "application"
	
	protected
	
	def require_user
		@user = nil
		
		if session[:user_id]
			@user = User.find(session[:user_id])
		end
		
		unless @user
			redirect_to "/auth/tumblr" and return
		end
		
	end

  def current_user
    @user
  end

end
