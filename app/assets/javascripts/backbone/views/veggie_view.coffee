class window.Veggie.View extends Backbone.View
	el: "article"
	initialize: ->
		self = this
		@model.fetch
			success: ->
				self.render()
	active: ->
		$("article > div").hide()
		$("#side_nav li[rel='" + @id + "']").addClass('active').siblings().removeClass("active")
		$("#" + @id).show()