#= require_tree ./lib
#= require hamlcoffee
#= require_tree ./templates
#= require_tree ./backbone/models
#= require ./backbone/mobile

$ ->
	new Mobile()