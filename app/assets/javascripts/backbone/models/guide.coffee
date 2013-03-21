class window.Guide extends Backbone.Model
	defaults:
		"num": 1
		"emotion": ''
		"text": ''
	@asset_emotion: (em) ->
		valid = ['common','surprise','sweet','bad','reward']
		if _.indexOf(valid,em) < 0
			em = 'common'
		"/assets/icon/7/#{em}.png"
	@generate: (num,em,text) ->
		new Guide
			emotion: Guide.asset_emotion("sweet")
			text: text
			num: num


	