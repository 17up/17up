class window.Veggie.CourseView extends Backbone.View
	tagName: 'li'
	className: "form alert-success"
	template: JST['item/member_course']
	events: ->
		"click b": "select"
	select: (e) ->
		$(e.currentTarget).toggleClass 'selected'
	render: ->
		@$el.html @template(@model.toJSON())
		#view = JST['item/master_course'](course)
		#JST['course_tips']()
		this