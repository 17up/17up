class window.Veggie.View extends Backbone.View
	el: "article"
	initialize: (self = this) ->
		$("#side_nav li[rel='" + @id + "']").addClass('active')
		Utils.loading $("nav .brand")	
		@model.fetch
			success: ->
				self.render()	
				Utils.loaded $("nav .brand")
				#setTimeout(->
				#	func	
				#,5000)	
	close: ->
		$("#" + @id).hide()
		$("#side_nav li[rel='" + @id + "']").removeClass('active')
	active: (callback = {}) ->
		$("#" + @id).show()
		window.route.active_view = this
		if typeof callback is 'function'
			callback()