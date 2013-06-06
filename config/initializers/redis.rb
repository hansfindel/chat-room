env = Rails.env 

env_eq = (env == "production" ) 

if env_eq 
	uri = URI.parse(ENV["REDISTOGO_URL"])
	$redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
else
	#REDIS = Redis.new(:host => 'localhost', :port => 6379, :db => 0) 
	$redis = Redis.new
end


