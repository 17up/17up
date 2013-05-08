class window.Olive.SongsView extends Olive.View
	id: 'songs'
	className: "block"
	template: JST['songs_view']
	collection: new Olive.Song()
	render: ->
		template = @template()
		@$el.html(template)				
		this
	extra: ->
		super()