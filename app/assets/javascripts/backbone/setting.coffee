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
		$(document).bind "keyup.nav",(e) ->
			switch e.keyCode
				when 32

					if $("nav").is(":visible")
						Setting.hide_nav()
					else
						Setting.show_nav()
					false
	@hide_nav: ->
		$("nav").animate 
			"top": "-86px"
			500
			 ->
			 	$(@).hide()
		$("aside").animate 
			"left":"-86px"
			500
			->
				$(@).hide()
	@show_nav: ->
		$("nav").show().animate 
			"top": "0px"
		$("aside").show().animate 
			"left":"0px"

