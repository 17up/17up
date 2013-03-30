class window.Guide extends Backbone.Model
	defaults:
		"emotion": 'sweet'
		"text": ''
	@asset_emotion: (em) ->
		valid = ['common','surprise','sweet','bad','reward']
		if _.indexOf(valid,em) < 0
			em = 'common'
		"/assets/icon/7/#{em}.png"
	@generate: (text,num = null) ->
		new Guide
			emotion: Guide.asset_emotion("sweet")
			text: text
			num: num
	@courses: (sense) ->
		guides = $.jStorage.get "guides_courses"
		if guides and guides[sense]
			Guide.generate guides[sense]
		else
			false
	@clear_courses: ->
		$.jStorage.deleteKey "guides_courses"

	@imagine: (sense) ->
		guides = $.jStorage.get "guides_imagine"
		if guides and guides[sense]
			Guide.generate guides[sense]
		else
			false

	