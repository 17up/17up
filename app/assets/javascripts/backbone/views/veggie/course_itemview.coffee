class window.Veggie.CourseView extends Backbone.View
	tagName: 'li'
	className: "form alert-success"
	template: JST['item/member_course']
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
	addCourseGuide: (sense) ->
		if model = Guide.courses(sense)
			view = new Veggie.GuideView
				model: model
			$(".action",@$el).after(view.render().el)
	addImagineGuide: (sense) ->
		if model = Guide.imagine(sense)
			view = new Veggie.GuideView
				model: model
			$("#" + sense).append(view.render().el)
			# destroy guide
	checkin: ->
		self = this
		@model.checkin ->
			self.addCourseGuide("content")
	select_words_from_collection: ->
		words = @collection.where
			exam: false
		titles = _.map words, (w) ->
			w.get("title")
		for w in titles
			$('b:contains("' + w + '")').addClass 'selected'
	study: ->
		@model.set 
			open: true
			imagine: false
		Veggie.hide_nav()
		@$el.siblings().hide()
		unless @model.get("has_checkin")
			@addCourseGuide("checkin")		
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
	back_to_list: ->
		@model.set 
			open: false
		@$el.siblings().show()
	save_step: ->
		cid = @model.get("_id")
		$.jStorage.set "course_#{cid}",$(".step.active").attr("id")
	back_to_content: ->
		@save_step()
		@model.set 
			open: true
			imagine: false
		if $("#imagine").jmpress("initialized")
			$("#imagine").jmpress "deinit"
			$("#imagine").hide()
			$("#icontrol").removeClass 'active'
			@$el.removeClass 'opacity'
		@addCourseGuide("back_content")
		@select_words_from_collection()

	toggleSelect: (e) ->
		$target = $(e.currentTarget)
		word = @collection.where
			title: $.trim($target.text())
		if $target.hasClass 'selected'
			$target.removeClass 'selected'
			word[0].imagine()
		else			
			$target.addClass 'selected'
			word[0].set 
				exam: false
	addEnd: ->
		self = this	
		# add end page
		word = new Word
			tip: "Imagine Never End"
			num: self.collection.length + 1
			end: "end"
		@collection.push word, id: "iend"
		@addImagineGuide("iend")
	addHome: (sum) ->
		# add front page
		word = new Word
			tip: "Start Imagine"
			num: 0
			sum: sum
		@collection.push word, id: "ihome"
		# add ihome guide if exsit
		@addImagineGuide("ihome")
	imagine_words: ->		
		# render
		@model.set
			open: true
			imagine: true		
		# init imagine
		unless $("#imagine").jmpress("initialized")			
			window.route.active_view.init_imagine()
			cid = @model.get("_id")
			if step = $.jStorage.get "course_#{cid}"
				$("#imagine").jmpress "goTo","#" + step
			$("#imagine").show()
		$("#icontrol").addClass 'active'
		@$el.addClass 'opacity'
		if document.createElement('input').webkitSpeech is undefined
			Utils.flash("请使用最新版本的chrome浏览器达到最佳学习效果","error")
	render: ->
		@$el.html @template(@model.toJSON())
		this