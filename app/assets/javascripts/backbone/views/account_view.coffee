#= require ./setting_view
#= require ../models/account
#= require ../templates/account_view

class window.Setting.AccountView extends Setting.View	
	id: "account"
	template: JST['backbone/templates/account_view']
	model: new Setting.Account()
	render: ->
		template = @template(providers: @model.get("providers"))
		$(@el).append(template)
		$("#" + @id).jmpress
			hash:
				use: false
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