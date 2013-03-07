class window.Utils
	@loading: ($item) ->
		$item.addClass 'disable_event'
		$item.queue (next) ->
			$(@).animate({opacity: 0.2},800).animate({opacity: 1},800)
			$(@).queue(arguments.callee)
			next()
	@loaded: ($item) ->
		$item.stop(true).css "opacity",1
		$item.removeClass 'disable_event'
	@flash: (msg,type='',style='') ->
		$flash = $("#flash_message")
		$flash.prepend("<div class='alert text_center hide'><strong></strong></div>")
		$alert = $(".alert",$flash)
		if type isnt ''
			$alert.addClass "alert-#{type}"
		if style isnt ''
			$alert.addClass "alert-#{style}"
		$("strong",$alert).text(msg)
		$alert.slideDown()
		fuc = -> 
			$alert.slideUp ->
				$(@).remove()
		setTimeout fuc,5000
		false
				