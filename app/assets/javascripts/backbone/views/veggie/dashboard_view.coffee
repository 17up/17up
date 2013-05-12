class window.Veggie.DashboardView extends Veggie.View
	id: "dashboard"
	className: "common"
	template: JST['dashboard_view']
	collection: new Veggie.Dashboard()
	add_song: ->
		model = new Song(@collection.get("song"))
		@song_view = new Veggie.SongView
			model: model
		$("#widgets",@$el).append(@song_view.render().el)
	add_courses: ->
		courses = new Veggie.Courses(@collection.get("courses"))
		for c in courses.models
			view = new Veggie.CourseView
				model: c
			$("#courses",@$el).append(view.render().el)
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
		template = @template(is_newer: @collection.has("guides"))
		@$el.html(template)
		this
	extra: ->
		if @collection.has("guides")
			guides = @collection.get("guides")
			Guide.fetch(guides)
			for g,i in guides["member"]
				@addOneGuide(Guide.generate(g,i+1))	
			$(document).on('keyup', @keyup)
		@add_song()
		@add_courses()
		window.chatroom = new Veggie.ChatView()
		super()