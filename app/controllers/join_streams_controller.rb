class JoinStreamsController < ApplicationController
  include ActionController::Live
  
  def index
	response.headers["Content-Type"] = "text/event-stream"
	3.times do |n|
	  response.stream.write "." 
      sleep 1
	end
    rescue IOError
      logger.info "Stream closed"
    ensure
      response.stream.close
  end

  def counter
  	response.headers["Content-Type"] = "text/event-stream"
    10.times do |n|
      response.stream.write "#{n}... \n"
      sleep 2
    end
    rescue IOError
      logger.info "Stream closed"
    ensure
      response.stream.close
  end


end
