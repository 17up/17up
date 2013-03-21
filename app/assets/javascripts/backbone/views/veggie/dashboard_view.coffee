class window.Veggie.DashboardView extends Veggie.View
	id: "dashboard"
	template: JST['dashboard_view']
	collection: new Veggie.Dashboard()	
	addOneGuide: (guide) ->
		view = new Veggie.GuideView
			model: guide
		$("#assets").append(view.render().el)
	render: ->
		template = @template
			quote: @collection.get("quote")
		@$el.append(template)
		@active()
		guides = [
			[1,"sweet","我是小柒，你的智能助手，感谢缘分让我们相遇，相信我，我会帮你学好英语的哦!"]
			[2,"sweet","接下来帮助你熟悉这里的基本操作啦～"]
		]
		for g in guides
			@addOneGuide(Guide.generate(g[0],g[1],g[2]))
	
		this