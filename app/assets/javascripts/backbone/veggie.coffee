#= require_self
#= require ./routers/veggie_router

class window.Veggie
	constructor: ->
		$("body").addClass 'veggie'
		Utils.uploader($(".avatar"),$(".avatar img"))
		window.route = new Veggie.Router()
		Backbone.history.start
			pushState: true
		$(document).bind "keyup.nav",(e) ->
			switch e.keyCode
				when 32
					if $("nav").is(":visible")
						Veggie.hide_nav()
					else
						Veggie.show_nav()
					false
	@hide_nav: ->
		$("nav").animate 
			"top": "-86px"
			500
			 ->
			 	$(@).hide()
			 	$("article .common").animate 'top':0
		$("aside").animate 
			"left":"-86px"
			500
			->
				$(@).hide()
				$("article").animate 'margin-left':0
	@show_nav: ->
		$("nav").show().animate 
			"top": "0px"
			500
			->
				$(@).css 'top':'auto'
		$("aside").show().animate 
			"left":"0px"
		$("article").animate 'margin-left':'86px'
		$("article .common").animate 'top':'86px'
