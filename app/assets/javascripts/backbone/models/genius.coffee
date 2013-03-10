class window.Setting.Genius extends Backbone.Model
	defaults: []
	url: "/members/genius"
	parse: (resp)->
		if resp.status is 0
			resp.data