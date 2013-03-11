#= require ./veggie_view
#= require ../models/genius
#= require ../templates/genius_view

class window.Veggie.GeniusView extends Veggie.View
	id: "genius"
	template: JST['backbone/templates/genius_view']
	model: new Veggie.Genius()
	render: ->
		template = @template(tags: @model.get("tags"))
		$(@el).append(template)
		@active()
		this