class window.Veggie.WordView extends Backbone.View
	tagName: 'div'
	className: 'step'
	template: JST['item/word']
	render: ->
		@$el.html @template(@model.toJSON())
		this