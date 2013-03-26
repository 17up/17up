class window.Veggie.Dashboard extends Backbone.Model
	url: "/members/dashboard"
	parse: (resp)->
		if resp.status is 0
			data = resp.data
			if data["courses"]
				for d in data["courses"]
					d["has_checkin"] = true
			data
			