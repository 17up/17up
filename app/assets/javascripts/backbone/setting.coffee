#= require_self
#= require ./routers/setting_router

class window.Setting
	constructor: ->
		$("body").addClass 'setting'
		Utils.uploader($(".avatar"),$(".avatar img"))
		route = new Setting.Router()
		Backbone.history.stop()
		Backbone.history.start
			pushState: true

