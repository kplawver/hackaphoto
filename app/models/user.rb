require 'lib/tumblr'

class User
	include MongoMapper::Document
	
	key :uid, String
	key :name, String
	key :blogs, Array, :default => []
	key :oauth_token, String
	key :oauth_secret, String
	
	def self.find_or_create_from_auth_hath(auth_hash)
	  user = User.first(:uid => auth_hash.uid)
	  if user.nil?
	    user = User.create(
	      :uid => auth_hash.uid,
	      :name => auth_hash.info.name,
	      :oauth_token => auth_hash.credentials.token,
	      :oauth_secret => auth_hash.credentials.secret
	    )
	  else
	    if user.oauth_token != auth_hash.credentials.token
	      user.set(:oauth_token => auth_hash.credentials.token, :oauth_secret => auth_hash.credentials.secret)
	      user.oauth_token = auth_hash.credentials.token
	      user.oauth_secret = auth_hash.credentials.secret
	    end
	  end
	  user
	end
	
	def self.consumer
	  @@consumer ||= OAuth::Consumer.new(ENV['TUMBLR_KEY'],ENV['TUMBLR_SECRET'],{
	    :site => "http://api.tumblr.com/v2",
	    :scheme => :header,
	    :http_method => :post
	  })
	end
	
	def client
	  @client ||= OAuth::AccessToken.new(User.consumer, self.oauth_token, self.oauth_secret)
	end
	
	def dashboard
	  
	end
	
end