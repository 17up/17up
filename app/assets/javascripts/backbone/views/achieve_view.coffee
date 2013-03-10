#= require ../templates/achieve_view

class window.Setting.AchieveView extends Backbone.View
	el: "article"
	template: JST['backbone/templates/achieve_view']
	initialize: ->
		@render()
	render: ->
		template = @template(achieve: @model)
		$(@el).html(template)

		this