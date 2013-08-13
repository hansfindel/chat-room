# Implementing "real time" in Rails 4
## with Pusher and (Rails 4) streaming

### Things you may want to cover:

* Ruby and Rails version
        
        ruby:  1.9.3  - specify to work on heroku
        rails: 4

* Database creation
		
		sqlDB + redis (redis start)

### Where are the codes examples
* Pusher
		
		Comments of Blogs work with Pusher
		In order to make it work:
		  Load pusher.js file (in application layout)
		  Create an account (add-on on heroku) and store keys
		  Send messages (blogs_controller.rb)
		  Receive messages on client side (blogs.js.coffee)

* Streaming (without Redis)

		ForumPosts on Forums work with normal streaming
		In order to make it work:
		  Add puma gem for a concurrent server (also may work: trinidad, unicorn)
	      Include ActionController::Live in the controller 
		  Create event action and a route for it (forums_controller.rb)
		  Receive messages and ask for more (forums.js.coffee)
			  
* Streaming (with Redis)

		Chats on Rooms work with streaming with Redis
		In order to make it work:
		  Add redis to gemfile
		  Similar to previous streaming example
			
### Conclusion 
In my opinion pusher is easier to install, but it comes to a price when increasing concurrent users. It allows you to separate your broadcast messenger (pusher) from your application, making it more de-coupled which leads to a better design in most cases. 

Using streaming without redis is just a step to test if it works, it is just a bad decision to let it work that way because of the high ammount of db calls needed. The problem with streaming (with redis) is the limitations of your own server to mantain those conections. Redis by itself has a limit (over that they charge you in heroku) and a server limitation (16 in puma), for more connections you should replicate servers which may be more difficult for early stages. 