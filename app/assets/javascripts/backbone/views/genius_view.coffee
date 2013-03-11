#= require ./setting_view
#= require ../models/genius
#= require ../templates/genius_view

class window.Setting.GeniusView extends Setting.View
	id: "genius"
	template: JST['backbone/templates/genius_view']
	model: new Setting.Genius()
	render: ->
		template = @template(model: @model)
		$(@el).append(template)
		@active()
		this