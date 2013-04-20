class window.Mobile.MediaView extends Backbone.View
	id: "#images"
	template: JST['genius_view']
	collection: new Mobile.Media()
	initialize: ->
		@collection.fetch
			url: "/mobile/fetch"
			success: =>
				$("article").append(@render().el)
	render: ->
		template = @template(tags: @collection.get("tags"))
		@$el.html(template)
		this