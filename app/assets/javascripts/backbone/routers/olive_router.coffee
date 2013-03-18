#= require_self
#= require_tree ../models/olive
#= require_tree ../views/olive

class Olive.Router extends Backbone.Router  
	initialize: ->
		self = this
		$("#side_nav li").click ->
			href = $(@).attr 'rel'
			$(@).addClass('active')
			self.navigate(href,true)
	routes:
		'':'quotes'
		'quotes': 'quotes'
		'persons': 'persons'
	before_change: ->
		if window.route.active_view
			window.route.active_view.close()
	quotes: ->
		@before_change()
		if @quotes_view
			@quotes_view.active()
		else
			@quotes_view = new Olive.QuotesView()
	persons: ->
		@before_change()
		if @persons_view
			@persons_view.active()
		else
			@persons_view = new Olive.PersonsView()
