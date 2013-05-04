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
	@uploader: ($ele,callback) ->				
		$uploader = $("footer #uploader").find("." + $ele.data().uploader)		
		$file = $("input[type='file']",$uploader)
		$form = $file.closest('form')
		$img = $("img",$ele)
		$form.off "ajax:success"
		$form.on "ajax:success",(d,data) ->
			if data.status is 0
				Utils.flash(data.msg,'success')
				if callback
					callback(data.data)
				else
					$img.attr("src",data.data)
			else
				Utils.flash(data.msg,'error')
		$file.off 'change'
		$file.on 'change', ->
			$form.submit()
		$file.trigger "click"
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
		$(document).delegate '.editable .textarea',"keydown.textarea",(e) ->
			switch e.keyCode
				when 9 # tab
					e.preventDefault()			
					if window.getSelection
						sel = window.getSelection()
						# 选中光标前面的单词
						sel.modify('move','left','word')
						sel.modify('extend','right','word')
						#Utils.getSelection()
						# setTimeout(->
						# 	sel.modify('move','right','word')
						# ,500)

		$textarea.bind 'blur', ->
			$textarea = $(@).closest("form").find("textarea")
			$textarea.val $(@).html().replace("&nbsp;",'')
		$textarea.focus ->
			if $.trim($(@).text()) is ''
				$(@).html("<div>&nbsp; </div>")
		$form.on "paste",".textarea",(e) ->
			Utils.flash("禁止粘贴内容哦")	
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
	@flash: (msg,type='',$container) ->
		$container = $container || $("#flash_message")
		$container.prepend JST['widget/flash'](msg:msg)
		$alert = $(".alert:first-child",$container)
		if type isnt ''
			$alert.addClass "alert-#{type}"
		$alert.slideDown()
		fuc = -> 
			$alert.slideUp ->
				$(@).remove()
		setTimeout fuc,5000
		false
	@wd_count: (string) ->
		cn_regx = /[\u4E00-\u9FA5\uf900-\ufa2d]/ig
		has_cn = string.match(cn_regx)
		if has_cn
			cn_count = has_cn.length
			string = string.replace(cn_regx,'')
		else
			cn_count = 0
		en_count = (_.compact(string.split(" "))).length
		en_count + cn_count
	@message: (avatar,msg,style = '',$container) ->
		$container = $container || $("#chatroom")
		wc = Utils.wd_count(msg)
		$container.prepend JST['widget/message'](avatar:avatar,msg:msg)
		$alert = $(".ms:first-child",$container)
		if style isnt ''
			$alert.addClass "ms-#{style}"
		$alert.css 		
			"-webkit-transform": "scale(0.3)"
			"opacity": "0"
			"-webkit-transition": "1s"
		fade_in = ->
			$alert.css 
				"-webkit-transform":"scale(1)"
				"opacity": "1"
		fade_out  = ->
			$alert.css 
				"-webkit-transform":"scale(1.5)"
				"opacity": "0.0"
			$alert.on "webkitTransitionEnd",->
				$(@).remove()
		setTimeout fade_in,100
		if wc > 6 
			duration = wc*1100 
		else
			duration = 7000
		setTimeout fade_out,duration
		false
	@confirm: (msg,yesCallback) ->
		$("body").prepend JST['widget/confirm'](msg:msg)
		$confirm = $("#confirm_dialog")
		$alert = $(".alert",$confirm)
		$("#container").addClass 'mask'
		$alert.fadeIn()
		$(".btn",$confirm).click ->
			if $(@).data().confirm is true
				yesCallback()	
			$confirm.remove()	
			$("#container").removeClass 'mask'
		false
	@highlight: ($el) ->		
		$el.css 
			"-webkit-transition": "2s"
			"-webkit-transform": "scale(2)"
		$el.on "webkitTransitionEnd",(e) ->
			$(@).css "-webkit-transform": "scale(1)"
			$(@).off "webkitTransitionEnd"