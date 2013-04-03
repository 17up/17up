class window.Olive.CourseView extends Backbone.View
	tagName: 'li'
	className: "form alert-success"
	template: JST['item/course']
	events:
		"click .edit": 'modify'
		"click .publish": 'publish'
		"click .preview": 'preview'
		"click .close_preview": "close_preview"
		"click .save": "save"
		"click .delete": "delete"
		"click .back": "back"
	initialize: ->
		@listenTo(@model, 'change', @render)
		@listenTo(@model, 'destroy', @remove)
	close_preview: ->
		@model.set 
			preview: false
	preview: ->	
		@model.set 
			preview: true
	back: ->
		@$el.siblings().show()
		@render()
	save: ->
		self = this
		@$el.find(".headline").show()
		obj = $("form",@$el).serializeArray()
		serializedData = {}
		$.each obj, (index, field)->
			serializedData[field.name] = field.value
		if serializedData['content'] isnt '' and serializedData['title'] isnt ''
			@model.save serializedData,success: (m,resp) ->
				self.model.set resp.data
				self.$el.siblings().show()
		else
			Utils.flash("请认真制作课程，内容不得为空","error")
	delete: ->
		self = this
		Utils.confirm "确认删除？", ->
			self.$el.siblings().show()
			self.model.destroy()
	modify: ->
		self = this
		@$el.siblings().hide()
		@$el.find(".headline").hide()
		@$el.find(".editor").html JST['form/course_form'](course: @model.toJSON())
		$form = $("form",@$el)
		Utils.tag_input($form)
		Utils.rich_textarea($form)		
	publish: (e) ->
		@model.ready()
		
	render: ->
		@$el.html @template(@model.toJSON())
		this