#= require ./veggie_view
#= require ../models/account
#= require ../templates/account_view

class window.Veggie.AccountView extends Veggie.View	
	id: "account"
	template: JST['backbone/templates/account_view']
	model: new Veggie.Account()
	close: ->
		Veggie.View.prototype.close.apply(this, arguments)
		if $("#" + @id).jmpress("initialized")
			$("#" + @id).jmpress "deinit"
	init_jmpress: ($ele = $("#" + @id)) ->
		#Utils.active_tab $(".step.active").attr("id")
		#$(".step",$wrap).on 'enterStep', (e) ->
		#	Utils.active_tab $(e.target).attr("id")
		$ele.jmpress
			mouse:
				clickSelects: false
			keyboard:
				keys:
					9: null
					32: null
		$(".step",$ele).on 'enterStep', (e) ->
			#$(e.target)
	render: ->
		template = @template(providers: @model.get("providers"))
		$(@el).append(template)		
		@active()
		@init_jmpress()
		this