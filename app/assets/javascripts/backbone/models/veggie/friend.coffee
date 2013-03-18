class window.Veggie.Friend extends Backbone.Model
	url: "/members/friend"
	parse: (resp)->
		if resp.status is 0
			resp.data