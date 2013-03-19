class window.Olive.CoursesView extends Olive.View
	id: 'courses'
	template: JST['courses_view']
	model: new Olive.Course()
	render: ->
		template = @template(courses: @model.get("courses"))
		$(@el).append(template)	
		@active()
		Utils.tag_input()
		Utils.rich_textarea()
		this