#= require_self
#= require ../views/account_view
#= require ../models/account
#= require ../views/achieve_view
#= require ../models/achieve
#= require ../views/genius_view
#= require ../models/genius

class Setting.Router extends Backbone.Router  
	initialize: ->
		self = this
		$("#side_nav li").click ->
			href = $(@).attr 'rel'
			self.navigate(href,trigger: true)
	routes:
		"account": "account"
		"achieve": "achieve"
		"genius": "genius"
	account: ->
		$("#side_nav li[rel='account']").addClass('active').siblings().removeClass("active")
		account = new Setting.Account()
		account.fetch
			success: (model)->
				new Setting.AccountView(model:model)
	achieve: ->
		$("#side_nav li[rel='achieve']").addClass('active').siblings().removeClass("active")
		achieve = new Setting.Achieve()
		new Setting.AchieveView(model:achieve)
		this
	genius: ->
		$("#side_nav li[rel='genius']").addClass('active').siblings().removeClass("active")
		genius = new Setting.Genius()
		new Setting.GeniusView(model:genius)
		this