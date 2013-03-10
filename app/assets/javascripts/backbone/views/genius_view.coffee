#= require ../templates/genius_view

class window.Setting.GeniusView extends Backbone.View
	el: "article"
	template: JST['backbone/templates/genius_view']
	initialize: ->
		@render()
	render: ->
		template = @template(model: @model)
		$(@el).html(template)

		this