class window.Veggie.CoursesShopView extends Backbone.View
	id: 'courses_shop'
	template: JST['courses_shop_view']
	collection: new Veggie.Courses()
	events: ->
		"click .golist": "golist"
	golist: ->
		@remove()
		if window.courses_list_view
			window.courses_list_view.show()
		else
			window.courses_list_view = new Veggie.CoursesView()
	initialize: ->
		$("#dashboard").append @render().el
		this
	addOne: (course) ->
		view = new Veggie.CourseView
			model: course
		@$el.append(view.render().el)
	addAll: (collection) ->	
		for c in collection.models
			@addOne(c)
	render: ->
		self = this
		template = @template()
		@$el.html(template)	
		@collection.fetch
			success: (data) ->
				self.addAll(data)
		this