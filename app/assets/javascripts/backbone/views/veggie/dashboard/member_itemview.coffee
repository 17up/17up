class window.Veggie.MemberView extends Backbone.View
	tagName: 'div'
	className: 'member'
	template: JST['item/member']
	initialize: ->
		@listenTo(@model, 'destroy', @remove)
	render: ->
		template = @template(@model.toJSON())
		@$el.html(template)
		this
	remove: ->
		@$el.animate
			"opacity":0
			500
			->
				$(@).remove()