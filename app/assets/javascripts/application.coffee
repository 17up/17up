#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require jquery.remotipart
#= require underscore
#= require backbone
#= require backbone_rails_sync
#= require backbone_datalink
#= require_tree ./lib
#= require backbone/welcome
#= require backbone/dashboard
#= require backbone/setting

$ ->
	$("span.close").click ->
		$(@).parent().slideUp ->
			$(@).remove()