class window.Veggie.DashboardView extends Veggie.View
	id: "dashboard"
	template: JST['dashboard_view']
	model: new Veggie.Dashboard()	
	render: ->
		template = @template(quote: @model.get("quote"),asset: @model.get("asset"))
		$(@el).append(template)
		@active()
		this