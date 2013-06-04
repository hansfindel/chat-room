# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery -> 
	url = $(".chat_room .messages").data("url")
	console.log(url)
	# source = new EventSource('/messages/events')
	source = new EventSource(url)
	source.addEventListener 'chat.add', (e) ->
		data = $.parseJSON(e.data)
		console.log(data)
		message = data.content
		#user = data.user
		chat_id = data.id
		console.log(message)
		#$('.messages_list').append($("<li class=#{chat_id} message>").text("#{user}: #{message}"))
		$('.messages_list').append( $("<li class=#{chat_id} message>").append( $("<p>").text(message)) )