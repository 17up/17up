#= require jquery
#= require jquery_ujs
#= require jquery.remotipart
#= require hamlcoffee
#= require underscore
#= require backbone
#= require backbone_rails_sync
#= require_tree ./lib
#= require ./backbone/mobile

$ ->
	new Mobile()