class window.Setting.Achieve extends Backbone.Model
	defaults: []
	url: "/members/achieve"
	parse: (resp)->
		if resp.status is 0
			resp.data