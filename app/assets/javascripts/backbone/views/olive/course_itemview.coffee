class window.Olive.CourseView extends Backbone.View
	tagName: 'li'
	className: "form alert-success"
	template: JST['item/course']
	events:
		"click .edit": 'modify'
		"click .publish": 'publish'
		"click .preview": 'preview'
		"click .close_preview": "close_preview"
	initialize: ->
		@listenTo(@model, 'change', @render)
		@listenTo(@model, 'destroy', @remove)
	close_preview: ->
		@model.set 
			preview: false
	preview: ->	
		@model.set 
			preview: true
	modify: ->
		self = this
		$headline = @$el.find(".headline").hide()
		@$el.find(".editor").html JST['form/course_form'](course: @model.toJSON())
		$form = $("form",@$el)
		Utils.tag_input($form)
		Utils.rich_textarea($form)		
		$form.on 'click','.save',->		
			$headline.show()
			obj = $form.serializeArray()
			serializedData = {}
			$.each obj, (index, field)->
      			serializedData[field.name] = field.value
			self.model.save serializedData,success: (m,resp) ->
				self.model.set resp.data
			false
		$form.on 'click',".delete",->
			Utils.confirm "确认删除？", ->
				self.model.destroy()

	publish: (e) ->
		@model.ready()
		
	render: ->
		@$el.html @template(@model.toJSON())
		this