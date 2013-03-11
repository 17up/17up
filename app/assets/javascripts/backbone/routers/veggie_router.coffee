#= require_self
#= require ../views/account_view
#= require ../views/achieve_view
#= require ../views/genius_view
#= require ../views/home_view

class Veggie.Router extends Backbone.Router  
	initialize: ->
		self = this
		$("#side_nav li").click ->
			href = $(@).attr 'rel'
			self.navigate(href,true)
	routes:
		"": "home"
		"account": "account"
		"achieve": "achieve"
		"genius": "genius"
	home: ->
		if @home_view
			@home_view.active()
		else
			@home_view = new Veggie.HomeView()
	account: ->
		if @account_view
			@account_view.active()	
		else
			@account_view = new Veggie.AccountView()
	achieve: ->
		if @achieve_view
			@achieve_view.active()
		else
			@achieve_view = new Veggie.AchieveView()
	genius: ->
		if @genius_view
			@genius_view.active()
		else
			@genius_view = new Veggie.GeniusView()