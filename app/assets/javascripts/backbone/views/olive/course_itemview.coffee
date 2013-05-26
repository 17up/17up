class window.Olive.CourseView extends Backbone.View
	tagName: 'li'
	className: "form alert-success"
	template: JST['item/o_course']
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
			editable: false
	back: ->
		@$el.siblings().show()
		@model.set editable: false
	save: ->
		self = this
		obj = $("form",@$el).serializeArray()
		serializedData = {}
		$.each obj, (index, field)->
			serializedData[field.name] = field.value
		Utils.loading @$el
		if serializedData['content'] isnt '' and serializedData['title'] isnt ''
			@model.save serializedData,success: (m,resp) ->
				self.model.set resp.data
				self.$el.siblings().show()
				Utils.loaded self.$el
		else
			Utils.flash("请确认课程标题及内容已填写","error",@$el.parent())
	delete: ->
		self = this
		Utils.confirm "确认删除？", ->
			self.$el.siblings().show()
			self.model.destroy()
	modify: ->
		self = this
		@$el.siblings().hide()
		@model.set editable: true
		$form = $("form",@$el)
		Utils.tag_input($form)
		$('textarea',$form).css('overflow', 'hidden').autogrow()	
	publish: (e) ->
		@model.ready()
		
	render: ->
		@$el.html @template(@model.toJSON())
		this