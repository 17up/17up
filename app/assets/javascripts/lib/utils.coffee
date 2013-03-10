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
	# single uploader
	@uploader: ($ele,$img) ->
		$file = $("input[type='file']",$ele.prev())
		$form = $file.closest('form')
		$form.bind "ajax:success",(d,data) ->
			if data.status is 0
				Utils.flash(data.msg,'success')
				$img.attr("src",data.data)
			else
				Utils.flash(data.msg,'error')
		$file.change ->
			$form.submit()
		$ele.click ->
			$file.trigger "click"
			false
		$form
	@active_tab: (id) ->
		$("ul.tab li a[href='#"+id+"']").parent().addClass('active').siblings().removeClass("active")
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
				