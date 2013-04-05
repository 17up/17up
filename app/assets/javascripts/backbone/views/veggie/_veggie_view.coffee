class window.Veggie.View extends Backbone.View
	initialize: (self = this) ->
		$("#side_nav li[rel='" + @id + "']").addClass('active')
		Utils.loading $("nav .brand")	
		@collection.fetch
			success: ->
				$("article").append(self.render().el)
				Utils.loaded $("nav .brand")			
				self.extra()
				self.active()
				#setTimeout(->
				#	func	
				#,5000)	
	close: ->
		@$el.hide()
		$("#side_nav li[rel='" + @id + "']").removeClass('active')
	active: ->
		@$el.show()
		window.route.active_view = this
	extra: ->
		this