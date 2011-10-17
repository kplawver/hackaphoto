class User
	include MongoMapper::Document
	
	key :tumblr_uid, String
	
	
end