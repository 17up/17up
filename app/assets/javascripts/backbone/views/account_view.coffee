#= require ../templates/account_view

class window.Setting.AccountView extends Backbone.View
	el: "article"
	template: JST['backbone/templates/account_view']
	initialize: ->
		@render()
	render: ->
		template = @template(providers: @model.toJSON()['providers'])
		$(@el).html(template)
		$wrap = $("#account")
		unless $wrap.jmpress('initialized')
			$wrap.jmpress()
		$wrap.show()
		#Utils.active_tab $(".step.active").attr("id")
		#$(".step",$wrap).on 'enterStep', (e) ->
		#	Utils.active_tab $(e.target).attr("id")
		
		this