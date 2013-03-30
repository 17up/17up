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
	
	@tag_input: ($form) ->
		$("input.tags",$form).tagsInput
			'height':'auto'
			'width':'auto'
			'defaultText':'添加标签'
			'placeholderColor': '#888'
	@rich_textarea: ($form) ->
		$textarea = $('.editable .textarea',$form)
		$('.editable .menu_bar',$form).on 'click', '.btn',(e) ->
			$this = $(@)
			switch $this.data().action
				# when "clean"
				# 	$textarea = $this.closest(".editable").find(".textarea")
				# 	$textarea.html $textarea.text()
				when "phrase"
					Utils.getSelection('Italic')
				when "word"
					Utils.getSelection('bold')
			e.preventDefault()
		$textarea.bind 'dblclick', ->		
			selection = Utils.getSelection()

		$textarea.bind 'blur', ->
			$textarea = $(@).closest("form").find("textarea")
			$textarea.val $(@).html()
		$textarea.focus()
		$form.on "paste",".textarea",(e) ->
			$ele = $(@)
			setTimeout(->
				html = "<p>"+$ele.html()+"</p>"
				text = $(html).contents().filter ->
					this.nodeType is 3
				text = _.map text,(t) ->
					"<p>" + t.data + "</p>"
				$ele.html text.join(" ")
				$ele.focus()
			,100)	
	@getSelection: (command = 'bold') ->
		if window.getSelection
			select = window.getSelection()
			if select.rangeCount
				range = select.getRangeAt(0)
				document.designMode = "on"
				select.removeAllRanges()
				select.addRange(range)
				document.execCommand(command, null, false)
				document.designMode = "off"
				$.trim(new String(select).replace(/^\s+|\s+$/g,''))

	@active_tab: (id) ->
		$("ul.tab li a[href='#"+id+"']").parent().addClass('active').siblings().removeClass("active")
	@flash: (msg,type='') ->
		$flash = $("#flash_message")
		$flash.prepend JST['flash']
		$alert = $(".alert",$flash)
		if type isnt ''
			$alert.addClass "alert-#{type}"
		$("strong",$alert).text(msg)
		$alert.slideDown()
		fuc = -> 
			$alert.slideUp ->
				$(@).remove()
		setTimeout fuc,5000
		false
	@confirm: (msg,yesCallback) ->
		$("body").prepend JST['confirm']
		$confirm = $("#confirm_dialog")
		$alert = $(".alert",$confirm)	
		$("strong",$confirm).text(msg)
		$("#container").addClass 'mask'
		$alert.fadeIn()
		$(".btn",$confirm).click ->
			if $(@).data().confirm is true
				yesCallback()	
			$confirm.remove()	
			$("#container").removeClass 'mask'
		false