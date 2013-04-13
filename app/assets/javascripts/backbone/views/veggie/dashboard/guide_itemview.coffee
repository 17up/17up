class window.Veggie.GuideView extends Backbone.View
	tagName: 'div'
	className: ->
		if @model.get("num") and @model.get("num") isnt 1
			'asset alert hide'
		else
			'asset alert'
	template: JST['item/guide']
	events:
		"click .next": 'next'
		"click .start": 'start'
	@addOne: (guide) ->
		if guide
			view = new Veggie.GuideView
				model: guide
			$("#assets").html(view.render().el)
	next: ->
		$next = @$el.next()
		$next.fadeIn()		
		@remove()
	start: ->
		$("#courses").fadeIn()
		@remove()
	render: ->
		self = this
		@$el.html @template(@model.toJSON())
		$form = $("#set_uid form",@$el)
		$form.bind 'ajax:before',(d) ->
			Utils.loading $("nav .brand")
		$form.bind 'ajax:success', (d,data) ->
			if data.status is 0	
				self.next()
				$("nav .gem").text("10")
			else
				Utils.flash(data.msg,"error")
			Utils.loaded $("nav .brand")
		this