# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery -> 
	Pusher.log = (message) ->
		window.console.log message  if window.console and window.console.log		

	key = $(".blog").data("key")
	console.log(key)
	channel_id = $(".blog").data("channel")
	console.log(channel_id)
	if( key && channel_id )
		pusher = new Pusher(key)
		channel = pusher.subscribe(channel_id)
		channel.bind 'comment', (data) ->
			console.log("data: ", data)
			$('.comments_list').append( $("<li class=comment>").append( $("<p>").text( data["content"] ) ) )
