class window.Veggie.PersonView extends Backbone.View
	id: "person"
	className: "left"
	template: JST['item/person']
	render: ->
		@$el.html @template(@model.toJSON())
		this