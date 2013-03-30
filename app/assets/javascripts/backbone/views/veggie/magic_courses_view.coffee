class window.Veggie.MagicCoursesView extends Backbone.View
	id: 'courses'
	template: JST['magic_courses_view']	
	addOne: (course) ->
		view = new Veggie.CourseView
			model: course
		@$el.append(view.render().el)
	addAll: (collection) ->	
		for c in collection.models
			@addOne(c)
		this
	render: ->
		template = @template()
		@$el.html(template)	
		this