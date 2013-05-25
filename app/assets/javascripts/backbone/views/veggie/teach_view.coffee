class window.Veggie.TeachView extends Veggie.View
	id: "teach"
	className: "common"
	template: JST['teach_view']
	collection: new Veggie.Teach()
	events:
		"click .new": 'newCourse'
	render: ->
		template = @template(is_teacher: window.current_member.get("is_teacher"))
		@$el.html(template)
		this
	newCourse: ->
		course = new Course()
		@addOne course
	addOne: (course) ->
		view = new Olive.CourseView
			model: course
		$("#t_courses",@$el).append(view.render().el)
	extra: ->
		if window.current_member.get("is_teacher")
			for c in @collection.models
				@addOne(c)
		else
			guide = Guide.generate "目前，“备课” 功能正在试验室阶段，你想成为一名 17up 教师吗？请通过任何方式联系我吧，感谢您的支持！"
			view = new Veggie.GuideView
				model: guide
			$("#t_assets").show().html(view.render().el)
		super()