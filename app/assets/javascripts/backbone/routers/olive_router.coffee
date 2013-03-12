#= require_self
#= require ../views/quotes_view

class Olive.Router extends Backbone.Router  
	initialize: ->
		self = this
		$("#side_nav li").click ->
			href = $(@).attr 'rel'
			self.navigate(href,true)
	routes:
		'o': 'quotes'
	quotes: ->
		if @quotes_view
			@quotes_view.active()
		else
			@quotes_view = new Olive.QuotesView()
