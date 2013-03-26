class window.Veggie.GeniusView extends Veggie.View
	id: "genius"
	className: "common"
	template: JST['genius_view']
	collection: new Veggie.Genius()
	render: ->
		template = @template(tags: @collection.get("tags"))
		@$el.html(template)
		this