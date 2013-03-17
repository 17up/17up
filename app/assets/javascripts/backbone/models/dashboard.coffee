class window.Veggie.Dashboard extends Backbone.Model
	asset_emotion: (em) ->
		valid = ['common','surprise','sweet','bad','reward']
		if _.indexOf(valid,em) < 0
			em = 'common'
		"/assets/icon/7/#{em}.png"
	url: "/members/dashboard"
	parse: (resp)->
		if resp.status is 0
			asset = 
				"emotion": @asset_emotion("sweet")
				"greet": "我是小柒，你的智能助手，感谢缘分让我们相遇，相信我，我会帮你学好英语的哦!"
			data = _.extend(resp.data,{"asset": asset})