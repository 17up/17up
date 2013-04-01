#= require jquery
#= require jquery_ujs
#= require jquery.remotipart
#= require hamlcoffee
#= require underscore
#= require backbone
#= require backbone_rails_sync
#= require backbone_datalink
#= require_tree ./lib
#= require_tree ./templates
#= require_tree ./backbone/models
#= require backbone/welcome
#= require backbone/veggie
#= require backbone/olive
#= require backbone/user_show

$ ->
	$('body').on 'click',"span.close", ->
		$(@).parent().slideUp ->
			$(@).remove()
	
	$init = $("footer #init")
	if $init.length is 1
		js_class = $("footer #init").data().js
		new window[js_class]