class window.Veggie.CourseView extends Backbone.View
	tagName: 'li'
	className: "form alert-success"
	template: JST['item/member_course']
	events: ->
		"click b": "select"
		"click .checkin": "checkin"
		"click .study": "study"
		"click .fetch_words":"fetch_words"
	initialize: ->
		@listenTo(@model, 'change', @render)
	checkin: ->
		@model.checkin()			
	study: ->
		console.log "good"
	select: (e) ->
		$(e.currentTarget).toggleClass 'selected'
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
	render: ->
		@$el.html @template(@model.toJSON())
		#view = JST['item/master_course'](course)
		#JST['course_tips']()
		this