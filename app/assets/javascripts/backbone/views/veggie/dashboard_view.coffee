class window.Veggie.DashboardView extends Veggie.View
	id: "dashboard"
	className: "common"
	template: JST['dashboard_view']
	collection: new Veggie.Dashboard()	
	active: ->
		super()
		$(document).on('keyup', @keyup)
		@init_imagine()
	close: ->
		super()
		$(document).off('keyup', @keyup)
		if $("#imagine").jmpress("initialized")
			$("#imagine").jmpress "deinit"
	init_imagine: ->
		if $("#imagine").html() isnt ''
			$("#imagine").jmpress
				transitionDuration: 0
				hash:
					use: false
				mouse:
					clickSelects: false
				keyboard:
					keys:
						9: null
						32: null
			#$("#imagine").jmpress("route", "#last", true)
			$("#imagine").jmpress("route", "#ihome", true, true)
	keyup: (event) ->
		switch event.keyCode
			when 39
				$(".next:visible").trigger("click")
	addOneGuide: (guide) ->
		view = new Veggie.GuideView
			model: guide
		$("#assets").append(view.render().el)
	addQuote: ->
		view = JST['item/quote'](q: @collection.get("quote"))
		$("#quote").html view
	render: ->
		template = @template(@collection.toJSON())
		@$el.html(template)
		this
	extra: ->
		if @collection.has("guides")
			for g,i in @collection.get("guides")
				@addOneGuide(Guide.generate(i+1,"sweet",g))			
		else if @collection.has("courses")
			collection = new Veggie.Courses(@collection.get("courses"))
			window.courses_list_view = (new Veggie.CoursesView()).addAll(collection)
		else
			new Veggie.CoursesShopView()
		super()