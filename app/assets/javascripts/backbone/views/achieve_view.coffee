#= require ./veggie_view
#= require ../models/achieve
#= require ../templates/achieve_view

class window.Veggie.AchieveView extends Veggie.View
	id: "achieve"
	template: JST['backbone/templates/achieve_view']
	model: new Veggie.Achieve()
	render: ->
		template = @template(achieve: @model)
		$(@el).append(template)
		@active()
		this