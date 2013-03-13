#= require ./veggie_view
#= require ../templates/dashboard_view
#= require ../models/dashboard

class window.Veggie.DashboardView extends Veggie.View
	id: "dashboard"
	template: JST['backbone/templates/dashboard_view']
	model: new Veggie.Dashboard()	
	render: ->
		template = @template
		$(@el).append(template)
		@active()
		this