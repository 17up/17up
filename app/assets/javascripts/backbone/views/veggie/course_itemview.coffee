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
	checkin: ->
		self = this
		@model.checkin ->
			self.addCourseGuide("content")
			
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
			for w,i in  _.uniq(words)
				word = new Word
					title: w
					num: i + 1
				@collection.push(word) 
	back_to_list: ->
		@model.set 
			open: false
		@$el.siblings().show()
	back_to_content: ->
		@model.set 
			open: true
			imagine: false
		if $("#imagine").jmpress("initialized")
			$("#imagine").jmpress "deinit"
			$('#imagine').html("")
			$("#icontrol").removeClass 'active'
			@$el.removeClass 'opacity'
		@addCourseGuide("back_content")
	toggleSelect: (e) ->
		$(e.currentTarget).toggleClass 'selected'
	addOneWord: (word,opts = {}) ->
		options = _.extend
			model: word
			opts
		view = new Veggie.WordView options			 
		new_step = view.render().el
		$("#imagine").append(new_step)
		# $("#imagine").jmpress("canvas").append(new_step)
		# $("#imagine").jmpress("init",new_step)
	imagine_words: ->
		self = this
		# add front page
		word = new Word
			tip: "Start Imagine"
			num: 0
			sum: self.collection.length
		@addOneWord word, id: "ihome"
		# add ihome guide if exsit
		@addImagineGuide("ihome")
		# render
		@model.set
			open: true
			imagine: true
		# add words piece			
		for word in @collection.models
			@addOneWord(word)
		# add end page
		word = new Word
			tip: "Imagine Never End"
			num: self.collection.length + 1
			end: "end"
		@addOneWord word, id: "iend"
		@addImagineGuide("iend")
		# init imagine
		unless $("#imagine").jmpress("initialized")
			window.route.active_view.init_imagine()
		$("#icontrol").addClass 'active'
		@$el.addClass 'opacity'
		$(".mytip").tooltip()
		
	render: ->
		@$el.html @template(@model.toJSON())
		this