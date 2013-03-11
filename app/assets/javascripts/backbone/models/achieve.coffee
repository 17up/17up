class window.Setting.Achieve extends Backbone.Model
	url: "/members/achieve"
	parse: (resp)->
		if resp.status is 0
			resp.data