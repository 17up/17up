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
		words = _.map $("b.selected"),(w) ->
			$(w).text()
		
		$("#words").siblings().hide()
		collection = new Veggie.Words(@collection.get("words"))
		for w in collection.models
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
	addCourse: ->
		if course = @collection.get("course")
			view = JST['item/master_course'](course)
			$("#course").append view
			$("#course").prepend JST['course_tips']()
		else
			@addQuote()
		$("#course .content").on "click","b",->
			$(@).toggleClass 'selected'
	render: ->
		template = @template()
		@$el.append(template)
		@active()

		if @collection.has("guides")
			for g,i in @collection.get("guides")
				@addOneGuide(Guide.generate(i+1,"sweet",g))
		else
			@addCourse()
	
		this