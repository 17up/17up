#= require jquery
#= require jquery_ujs
#= require jquery.remotipart
#= require hamlcoffee
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
	$init = $("footer #init")
	if $init.length is 1
		js_class = $("footer #init").data().js
		new window[js_class]