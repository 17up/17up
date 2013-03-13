#= require_self
#= require ../views/account_view
#= require ../views/achieve_view
#= require ../views/genius_view
#= require ../views/dashboard_view

class Veggie.Router extends Backbone.Router  
	initialize: ->
		self = this
		$("#side_nav li").click ->
			href = $(@).attr 'rel'
			$(@).addClass('active')
			if href is 'dashboard'
				href = ''
			self.navigate(href,true)
	routes:
		"": "home"
		"account": "account"
		"achieve": "achieve"
		"genius": "genius"
	before_change: ->
		if window.route.active_view
			window.route.active_view.close()
	home: ->
		@before_change()
		if @dashboard_view
			@dashboard_view.active()
		else
			@dashboard_view = new Veggie.DashboardView()
	account: ->
		@before_change()
		if @account_view
			@account_view.active()	
		else
			@account_view = new Veggie.AccountView()
	achieve: ->
		@before_change()
		if @achieve_view
			@achieve_view.active()
		else
			@achieve_view = new Veggie.AchieveView()
	genius: ->
		@before_change()
		if @genius_view
			@genius_view.active()
		else
			@genius_view = new Veggie.GeniusView()