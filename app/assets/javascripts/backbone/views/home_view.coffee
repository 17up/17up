#= require ./veggie_view
#= require ../templates/home_view

class window.Veggie.HomeView extends Veggie.View
	id: ""
	template: JST['backbone/templates/home_view']
	initialize: ->
		@render()
	render: ->
		template = @template
		$(@el).append(template)
		@active()
		this