class window.Veggie.DashboardView extends Veggie.View
	id: "dashboard"
	className: "common"
	template: JST['dashboard_view']
	collection: new Veggie.Dashboard()

	active: ->
		super()		
		@init_imagine()
	close: ->
		super()
		@deinit_imagine()
	deinit_imagine: ->
		if $("#imagine").jmpress("initialized")
			$("#imagine").jmpress "deinit"
		$("#imagine").hide()
		$("#icontrol").removeClass 'active'
		@$el.css "height":"auto"
	init_imagine: ->
		unless $("#imagine").jmpress("initialized")
			if @current_course
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
				$("#imagine").jmpress("route", "#iend", true)
				$("#imagine").jmpress("route", "#ihome", true, true)
				cid = @current_course.get("_id")
				if step = $.jStorage.get "course_#{cid}"
					$("#imagine").jmpress "goTo","#" + step
				$("#imagine").show()
				$("#icontrol").addClass 'active'
				@$el.css "height":"100%"
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
		courses = new Veggie.Courses(@collection.get("courses"))
		options = {}
		if @collection.has("guides")
			guides = @collection.get("guides")
			Guide.fetch(guides)
			for g,i in guides["member"]
				@addOneGuide(Guide.generate(g,i+1))	
			$(document).on('keyup', @keyup)
			options =	
				className: 'hide'
		magic_courses_view = new Veggie.MagicCoursesView options
		@$el.append magic_courses_view.render().el
		magic_courses_view.addAll(courses)
		super()