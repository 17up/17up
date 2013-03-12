#= require_self
#= require ./routers/olive_router

class window.Olive
	constructor: ->
		$("body").addClass 'olive'
		route = new Olive.Router()
		Backbone.history.start
			pushState: true
			root: 'o'