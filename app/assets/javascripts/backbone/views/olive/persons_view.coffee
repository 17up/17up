class window.Olive.PersonsView extends Olive.View
	id: 'persons'
	template: JST['persons_view']
	model: new Olive.Person()
	render: ->
		template = @template(persons: @model.get("persons"))
		$(@el).append(template)	
		@active()
		this