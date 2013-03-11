#= require ./veggie_view
#= require ../models/account
#= require ../templates/account_view

class window.Veggie.AccountView extends Veggie.View	
	id: "account"
	template: JST['backbone/templates/account_view']
	model: new Veggie.Account()
	render: ->
		console.log @model.get("providers")
		template = @template(providers: @model.get("providers"))
		$(@el).append(template)
		$("#" + @id).jmpress
			#hash:
			#	use: false
			mouse:
				clickSelects: false
			keyboard:
				keys:
					9: null
					32: null
		
		#Utils.active_tab $(".step.active").attr("id")
		#$(".step",$wrap).on 'enterStep', (e) ->
		#	Utils.active_tab $(e.target).attr("id")
		@active()
		this