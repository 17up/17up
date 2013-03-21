class window.Olive.PersonsView extends Olive.View
	id: 'persons'
	template: JST['persons_view']
	collection: new Olive.Person()
	render: ->
		template = @template(persons: @collection.get("persons"))
		$(@el).append(template)	
		@active()
		this