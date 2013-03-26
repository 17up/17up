class window.Veggie.CoursesView extends Backbone.View
	id: 'courses'
	template: JST['courses_list_view']
	events: ->
		"click .goshop": "goshop"
	initialize: ->
		$("#dashboard").append @render().el
		this	
	show: ->
		@$el.show()
	goshop: ->
		@$el.hide()
		new Veggie.CoursesShopView()
	addOne: (course) ->
		view = new Veggie.CourseView
			model: course
		@$el.append(view.render().el)
	addAll: (collection) ->	
		for c in collection.models
			@addOne(c)
		this
	render: ->
		self = this
		template = @template()
		@$el.html(template)	

		this