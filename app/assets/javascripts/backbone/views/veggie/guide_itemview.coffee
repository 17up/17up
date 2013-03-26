class window.Veggie.GuideView extends Backbone.View
	tagName: 'div'
	className: 'asset alert hide'
	template: JST['item/guide']
	events:
		"click .next": 'next'
		"click .start": 'start'
	next: ->
		$next = @$el.next()
		$next.fadeIn()		
		@remove()
	start: ->
		new Veggie.CoursesShopView()
		@remove()
	render: ->
		self = this
		if @model.get("num") is 1
			@$el.show()
		@$el.html @template(@model.toJSON())
		$("#set_uid form",@$el).bind 'ajax:success', (d,data) ->
			if data.status is 0	
				self.next()
				$("nav .gem").text("10")
			else
				Utils.flash(data.msg,"error")
		this