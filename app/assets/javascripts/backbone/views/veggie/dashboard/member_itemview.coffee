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
		@$el.css "-webkit-transform":"scale(0.0)"
		@$el.on "webkitTransitionEnd",(e) ->
			$(@).remove()