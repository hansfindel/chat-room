class StaticController < ApplicationController
  def index
  	if current_user 
  		Pusher['test_channel'].trigger('my_event', {:message => "#{current_user.username} is around"})
  	else  	
  		Pusher['test_channel'].trigger('my_event', {:message => 'A stranger is around'})
  	end
  end
end
