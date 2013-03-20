#= require 'backbone/models/item/course'

class window.Olive.CoursesView extends Olive.View
	id: 'courses'
	template: JST['courses_view']
	model: new Olive.Course()
	init_form: (data) ->
		$wrap = $("#create",$("#" + @id))
		view = JST['form/course_form'](course: data.toJSON())
		$(".form",$wrap).html view
		Utils.tag_input()
		Utils.rich_textarea()
		@draft()
	modify: ->
		self = this	
		$("#course_list .action .edit").click ->
			_id = $(@).closest("li").data().cid
			course = new Course()
			course.fetch
				url: "/courses/show?id=" + _id
				success: (data) ->
					self.init_form(data)
	sync: ->
		$("#course_list .action .sync").click ->
			$ele = $("i",$(@))
			$ele.addClass 'spin'
			_id = $(@).closest("li").data().cid
			data = Course.find(_id).toJSON()
			$.post "/courses/sync",data,(data)->
				if data.status is 0	
					$ele.removeClass 'spin'
	draft: ->
		$wrap = $("#create",$("#" + @id))
		$form = $("form",$wrap)	
		$form.on 'submit',->
			$form[0].reset()
			$('.tags',$form).importTags('')	
			$('.textarea',$form).html('')
	render: ->
		template = @template(courses: @model.get("courses"))
		$(@el).append(template)	
		@active()
		@init_form(new Course())
		@modify()
		this