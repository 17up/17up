class window.Olive.View extends Backbone.View
	el: "article"
	initialize: (self = this) ->
		$("#side_nav li[rel='" + @id + "']").addClass('active')
		Utils.loading $("aside .brand")	
		@collection.fetch
			success: ->
				self.render()	
				Utils.loaded $("aside .brand")
	close: ->
		$("#" + @id).hide()
		$("#side_nav li[rel='" + @id + "']").removeClass('active')
	active: (callback = {}) ->
		$("#" + @id).show()
		window.route.active_view = this
		if typeof callback is 'function'
			callback()