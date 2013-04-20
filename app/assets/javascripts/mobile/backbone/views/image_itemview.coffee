class window.Mobile.ImageView extends Backbone.View
	tagName: 'div'
	className: ".image"
	render: ->
		@$el.html @template(@model.toJSON())
		this