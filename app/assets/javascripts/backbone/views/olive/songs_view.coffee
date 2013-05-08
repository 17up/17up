class window.Olive.SongsView extends Olive.View
	id: 'songs'
	template: JST['songs_view']
	collection: new Olive.Song()
	render: ->
		template = @template()
		@$el.html(template)				
		this