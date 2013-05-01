class window.Veggie.MemberView extends Backbone.View
	tagName: 'div'
	className: 'member'
	template: JST['item/member']
	initialize: ->
		@listenTo(@model, 'change', @render)
		@listenTo(@model, 'say', @say)
		@$el.on "webkitTransitionEnd",(e) ->
			$(@).removeClass("highlight")
	render: ->
		template = @template(@model.toJSON())
		@$el.html(template)
		this
	say: ->
		@$el.addClass("highlight")


			
