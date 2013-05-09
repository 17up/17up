class window.Olive.SongsView extends Olive.View
	id: 'songs'
	className: "block"
	template: JST['songs_view']
	collection: new Olive.Song()
	events:
		"paste #upload_songs textarea": "parse_lyrics"
	render: ->
		template = @template()
		@$el.html(template)				
		this
	parse_lyrics: (e) ->
		setTimeout(=>
			text = $(e.currentTarget).val()
			lyrics = new Lrc text
			tags = lyrics.tags
			$("input[name='title']",@$el).val(tags["title"])
			$("input[name='artist']",@$el).val(tags["artist"])
			$("input[name='album']",@$el).val(tags["album"])
			if $.trim(tags["title"]) isnt ''
				@model = new Song()
				$form = $(e.currentTarget).closest("form")
				obj = $form.serializeArray()
				serializedData = {}
				$.each obj, (index, field)->
					serializedData[field.name] = field.value
				@model.save serializedData,success: (m,resp) =>
					@model.set resp.data
					$form.reset()
		,100)	
	extra: ->	
		super()