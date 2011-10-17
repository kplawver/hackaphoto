class UsersController < ApplicationController
	
	before_filter :require_user, :except => [:callback]
	
	def index
	  
	end
	
	def dashboard
	  c = current_user.client
	  offset = params[:offset] || 0
	  offset = offset.to_i
	  
	  Rails.logger.debug("OFfset: #{offset}")
	  
	  url = "http://api.tumblr.com/v2/user/dashboard?type=photo"
	  
	  if offset > 0
	    url << "&offset=#{offset}"
	  end
	  
	  r = c.get(url).body
	  if params[:cb]
	    r = "#{params[:cb]}(r)"
	  end
	  respond_to do |format|
	    format.json { render :json => r }
	  end
	end
	
	def callback
	  Rails.logger.debug("Auth Hash: #{auth_hash.inspect.to_s}")
    @user = User.find_or_create_from_auth_hath(auth_hash)
    session[:user_id] = @user.id
    flash[:notice] = "Welcome back!"
    redirect_to root_url and return
#		@user = User.find_or_create_from_auth_hash(auth_hash)
#		session[:user_id] = @user.id
#		redirect_to root_url and return
	end
	
	protected
	
	def auth_hash
		request.env['omniauth.auth']
	end
	
end