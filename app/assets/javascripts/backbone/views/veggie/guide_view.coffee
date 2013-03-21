class window.Veggie.GuideView extends Backbone.View
	tagName: 'div'
	className: 'asset alert hide'
	template: JST['item/guide']
	events:
		"click .next": 'next'
	next: ->
		@$el.hide()
		@$el.next().fadeIn()
	render: ->
		if @model.get("num") is 1
			@$el.show()
		@$el.html @template(@model.toJSON())
		this