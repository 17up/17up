#= require_self
#= require ../views/account_view
#= require ../views/achieve_view
#= require ../views/genius_view

class Setting.Router extends Backbone.Router  
	initialize: ->
		self = this
		$("#side_nav li").click ->
			href = $(@).attr 'rel'
			self.navigate(href,true)
	routes:
		"account": "account"
		"achieve": "achieve"
		"genius": "genius"
	account: ->
		if @account_view
			@account_view.active()	
		else
			@account_view = new Setting.AccountView()
	achieve: ->
		if @achieve_view
			@achieve_view.active()
		else
			@achieve_view = new Setting.AchieveView()
	genius: ->
		if @genius_view
			@genius_view.active()
		else
			@genius_view = new Setting.GeniusView()