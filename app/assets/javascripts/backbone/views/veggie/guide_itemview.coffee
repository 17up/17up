class window.Veggie.GuideView extends Backbone.View
	tagName: 'div'
	className: 'asset alert hide'
	template: JST['item/guide']
	events:
		"click .next": 'next'
	next: ->
		$next = @$el.next()
		$next.fadeIn()		
		switch @model.get("num")
			when 3
				window.route.active_view.addCourse()
		@remove()
	render: ->
		self = this
		if @model.get("num") is 1
			@$el.show()
		@$el.html @template(@model.toJSON())
		$form = $("#set_uid form",@$el)
		$form.bind 'ajax:success', (d,data) ->
			if data.status is 0	
				self.next()
				$("nav .gem").text("10")
			else
				Utils.flash(data.msg,"error")
		this