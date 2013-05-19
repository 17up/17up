class window.Veggie.CourseView extends Backbone.View
	tagName: 'li'
	template: JST['item/course']
	collection: new Veggie.Words()
	events: ->
		"click b": "toggleSelect"
		"click .checkin": "checkin"
		"click .study": "study"
		"click .imagine_words": "imagine_words"
		"click .back-to-list": "back_to_list"
		"click .back-to-content": "back_to_content"
	initialize: ->
		@listenTo(@model, 'change', @render)
	checkin: ->
		@model.checkin =>
			Veggie.GuideView.addOne Guide.courses("content")
			@select_words_from_collection()
	select_words_from_collection: ->
		words = @collection.where
			imagine: false
		titles = _.map words, (w) ->
			w.get("title")
		for w in titles
			$('b:contains("' + w + '")').addClass 'selected'
	study: ->
		@model.set 
			open: true
			imagine: false
		Veggie.hide_nav()
		@$el.parent().siblings().hide()
		@$el.siblings().hide()	
		window.route.active_view.current_course = @model
		unless @model.get("has_checkin")
			Veggie.GuideView.addOne Guide.courses("checkin")		
		if @collection.length is 0			
			$words = $("b",@$el).addClass 'selected'
			words = _.map $words,(w) ->
				$(w).text()
			words = _.uniq(words)
			@addHome(words.length)
			for w,i in words
				word = new Word
					title: $.trim(w)
					num: i + 1
				@collection.push(word) 
			@addEnd()
		else
			@select_words_from_collection()
		window.chatroom.enter_channel(@model.get("_id"))
	back_to_list: ->
		@model.set 
			open: false
		@$el.siblings().show()
		@$el.parent().siblings().show()
		$("#assets").html ""		
		@collection.reset()
		$("#imagine").html ""
		window.chatroom.leave_channel()
	save_step: (id) ->
		cid = @model.get("_id")
		$.jStorage.set "course_#{cid}",id
	back_to_content: ->
		$word = $(".step.active")
		@save_step $word.attr("id")
		@model.set 
			open: true
			imagine: false
		window.route.active_view.deinit_imagine()
		@$el.removeClass 'opacity'
		Veggie.GuideView.addOne Guide.courses("back_content")
		@select_words_from_collection()
		# w = $.trim($(".title",$word).text())
		# Utils.highlight $('b:contains("' + w + '")')
		
	toggleSelect: (e) ->
		$target = $(e.currentTarget)
		word = @collection.where
			title: $.trim($target.text())
		if $target.hasClass 'selected'
			$target.removeClass 'selected'
			word[0].set 
				imagine: true
		else			
			$target.addClass 'selected'
			word[0].set 
				imagine: false
	addEnd: ->
		# add end page
		word = new Word
			tip: "Imagine Never End"
			num: @collection.length
			end: "end"
		@collection.push word, id: "iend"
	addHome: (sum) ->
		# add front page
		word = new Word
			tip: "Start Imagine"
			num: 0
			sum: sum
		@collection.push word, id: "ihome"
	imagine_words: ->		
		# render
		@model.set
			open: true
			imagine: true		
		# init imagine
		window.route.active_view.init_imagine()
		@$el.addClass 'opacity'
		if document.createElement('input').webkitSpeech is undefined
			Utils.flash("请使用最新版本的chrome浏览器达到最佳学习效果","error")
	render: ->
		@$el.html @template(@model.toJSON())
		this