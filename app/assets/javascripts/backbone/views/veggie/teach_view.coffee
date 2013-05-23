class window.Veggie.TeachView extends Veggie.View
	id: "teach"
	className: "common"
	template: JST['teach_view']
	collection: new Veggie.Teach()
	render: ->
		template = @template()
		@$el.html(template)
		this