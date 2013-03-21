class window.Olive.CoursesView extends Olive.View
	id: 'courses'
	template: JST['courses_view']
	collection: new Olive.Courses()
	events:
		"click .new": 'newCourse'
	newCourse: ->
		course = new Course()
		@addOne course
	addOne: (course) ->
		view = new Olive.CourseView
			model: course
		$("#course_list").append(view.render().el)
	render: ->
		template = @template()
		$(@el).append(template)	
		@active()
		for c in @collection.models
			@addOne(c)	
		this