class window.Veggie.GeniusView extends Veggie.View
	id: "genius"
	template: JST['genius_view']
	model: new Veggie.Genius()
	render: ->
		template = @template(tags: @model.get("tags"))
		$(@el).append(template)
		@active()
		this