class window.Olive.CourseView extends Backbone.View
	tagName: 'li'
	className: "form alert-success"
	template: JST['item/o_course']
	events:
		"click .edit": 'modify'
		"click .publish": 'publish'
		"click .next": "next"
		"click .delete": "delete"
		"click .back": "back"
	initialize: ->
		@listenTo(@model, 'change', @render)
		@listenTo(@model, 'destroy', @remove)
	back: ->
		@$el.siblings().show()
		@model.set editable: false
	next: ->
		self = this
		obj = $("form",@$el).serializeArray()
		serializedData = {}
		$.each obj, (index, field)->
			serializedData[field.name] = field.value
		if serializedData['content'] isnt '' and serializedData['title'] isnt ''
			Utils.loading @$el
			@model.save serializedData,success: (m,resp) ->
				data = _.extend resp.data, next: true
				self.model.set data			
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
		@model.ready content, =>
			@$el.siblings().show()
		
	render: ->
		@$el.html @template(@model.toJSON())
		this