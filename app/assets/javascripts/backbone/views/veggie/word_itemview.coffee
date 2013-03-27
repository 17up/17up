class window.Veggie.WordView extends Backbone.View
	tagName: 'div'
	className: 'step word'
	id: ->
		@model.get('title')
	attributes: ->
		"data-x": @model.get('num')*1000
		"data-y": "1800" 
		"data-z": "3000" 
		"data-scale": "1"
	template: JST['item/word']
	initialize: ->
		@listenTo(@model, 'change', @render)
		@listenTo(@model, 'destroy', @remove)
	render: ->
		@$el.html @template(@model.toJSON())
		this