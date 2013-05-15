class window.Veggie.PersonView extends Backbone.View
	id: "person"
	className: "left"
	template: JST['item/person']
	events:
		"click .enter": "enter"
	render: ->
		@$el.html @template(@model.toJSON())
		this
	enter: (e) ->
		@open = true
		$("body").css "overflow":"hidden"
		@$el.addClass "enter_in"
		$action = $(e.currentTarget).parent()
		Veggie.hide_nav =>
			width = $(window).width() - 48
			@$el.removeClass("left").animate
				"width": width + "px"
				800
				-> 
					$(@).css "width": "auto"
					$action.css 
						"-webkit-transform": "translateX(0)"
		@$el.parent().siblings().hide()
		@$el.siblings().hide()