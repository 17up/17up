class window.Olive.CourseView extends Backbone.View
	tagName: 'li'
	className: "form alert-success"
	template: JST['item/course']
	events:
		"click .edit": 'modify'
		"click .sync": 'sync'
	initialize: ->
		@listenTo(@model, 'change', @render)
		@listenTo(@model, 'destroy', @remove)
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
			self.model.save serializedData
			false
		$form.on 'click',".delete",->
			Utils.confirm "确认删除？", ->
				self.model.destroy()
	sync: (e) ->
		self = this
		$icon = $("i",$(e.target)).addClass 'icon-spin'
		data = @model.toJSON()
		$.post "/courses/sync",data,(data)->
			if data.status is 0	
				$icon.removeClass 'icon-spin'
				self.model.set 
					status: 2
	render: ->
		@$el.html @template(@model.toJSON())
		this