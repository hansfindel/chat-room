# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery -> 
	url = $(".forum .messages").data("url")
	room_id = $(".forum").data("forum")
	if(url != null)
		console.log(url)
		source = new EventSource(url)
		console.log(source)
		event_name = 'forum_post'
		console.log(event_name)
		source.addEventListener event_name, (e) ->
			console.log(e)
			data = $.parseJSON(e.data)
			type = e.type
			message = data.content
			new_id = data.id
			message_id = "post_" + new_id
			console.log("type: ", type)
			console.log("message: ", message)
			console.log("message_id: ", message_id)
			last = $('.posts_list li').last()[0]
			if(last)
				last_id = last.className.split("_")[1]
				console.log("last: ", last_id)
				if(Number(last_id) < Number(new_id))
					$('.posts_list').append($("<li class=#{message_id}>").text("#{message}"))
			else
				$('.posts_list').append($("<li class=#{message_id}>").text("#{message}"))