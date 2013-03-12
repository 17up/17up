class window.Veggie.View extends Backbone.View
	el: "article"
	initialize: ->
		self = this
		@model.fetch
			success: ->
				self.render()
	close: ->
		$("article > div").hide()
	active: (callback = {}) ->
		@close()	
		$("#side_nav li[rel='" + @id + "']").addClass('active').siblings().removeClass("active")
		$("#" + @id).show()
		if typeof callback is 'function'
			callback()