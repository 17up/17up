#= require ./setting_view
#= require ../models/achieve
#= require ../templates/achieve_view

class window.Setting.AchieveView extends Setting.View
	id: "achieve"
	template: JST['backbone/templates/achieve_view']
	model: new Setting.Achieve()
	render: ->
		template = @template(achieve: @model)
		$(@el).append(template)
		@active()
		this