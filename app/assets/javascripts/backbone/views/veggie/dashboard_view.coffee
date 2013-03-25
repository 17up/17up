class window.Veggie.DashboardView extends Veggie.View
	id: "dashboard"
	template: JST['dashboard_view']
	collection: new Veggie.Dashboard()	
	events: ->
		"click .fetch_words":"fetch_words"
	addOneWord: (word) ->
		view = new Veggie.WordView
			model: word 
		$("#words").append(view.render().el)
	fetch_words: ->
		self = this
		selected_words = _.map $("b.selected"),(w) ->
			$(w).text()		
		$("#words").siblings().hide()
		words = new Veggie.Words()
		for w in words.models
			if selected_words.length is 0
				self.addOneWord(w)
			else
				if _.indexOf(selected_words, w.title) isnt -1
					self.addOneWord(w)

	active: ->
		super()
		$(document).on('keyup', @keyup)
	close: ->
		super()
		$(document).off('keyup', @keyup)
	keyup: (event) ->
		switch event.keyCode
			when 39
				$(".next:visible").trigger("click")
	addOneGuide: (guide) ->
		view = new Veggie.GuideView
			model: guide
		$("#assets").append(view.render().el)
	addQuote: ->
		view = JST['item/quote'](q: @collection.get("quote"))
		$("#quote").html view
	addOneCourse: (course) ->
		view = new Veggie.CourseView
			model: course
		$("#courses").append(view.render().el)
	addAllCourses: (collection) ->	
		for c in collection.models
			@addOneCourse(c)
	render: ->
		self = this
		template = @template()
		@$el.append(template)
		@active()

		if @collection.has("guides")
			for g,i in @collection.get("guides")
				@addOneGuide(Guide.generate(i+1,"sweet",g))
		else if @collection.has("courses")
			collection = new Veggie.Courses(@collection.get("courses"))
			@addAllCourses(collection)
		else
			collection = new Veggie.Courses()
			collection.fetch
				success: (data) ->
					self.addAllCourses(data)
	
		this