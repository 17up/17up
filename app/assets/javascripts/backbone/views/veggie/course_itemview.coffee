class window.Veggie.CourseView extends Backbone.View
	tagName: 'li'
	className: "form alert-success"
	template: JST['item/member_course']
	selected_words: []
	events: ->
		"click b": "select"
		"click .checkin": "checkin"
		"click .study": "study"
		"click .imagine_words": "imagine_words"
		"click .back-to-list": "back_to_list"
		"click .back-to-content": "back_to_content"
	initialize: ->
		@listenTo(@model, 'change', @render)
	checkin: ->
		@model.checkin()
		window.courses_list_view.addOne(@model)		
	study: ->
		@model.set 
			open: true
			tips: "请尝试阅读以下段落，红色单词为推荐学习，你也可以点击选中其中一部分"
			imagine: false
		Veggie.hide_nav()
		$(".headline").hide()
	back_to_list: ->
		@model.set 
			open: false
		$(".headline").show()
		
	back_to_content: ->
		@model.set 
			open: true
			tips: "继续阅读课文，看看是否记住刚才学习的单词了呢～"
			imagine: false
		if $("#imagine").jmpress("initialized")
			$("#imagine").jmpress "deinit"
			$('#imagine').html("")
	select: (e) ->
		$(e.currentTarget).toggleClass 'selected'
	addOneWord: (word) ->
		view = new Veggie.WordView
			model: word 
		new_step = view.render().el
		$("#imagine").append(new_step)
		# $("#imagine").jmpress("canvas").append(new_step)
		# $("#imagine").jmpress("init",new_step)
	imagine_words: ->
		if $("b.selected",@$el).length is 0
			$words = $("b",@$el)
		else
			$words = $("b.selected",@$el)			
		new_selected_words = _.map $words,(w) ->
			$(w).text()	

		@selected_words = _.union(@selected_words,new_selected_words)
		$('#imagine').prepend JST['item/imagine_home'](num: @selected_words.length)
		@model.set
			open: true
			imagine: true
			tips: "请使用键盘方向键操作"			
		for w,i in @selected_words
			word = new Word
				title: w
				num: i + 1
			@addOneWord(word)
		
		unless $("#imagine").jmpress("initialized")
			window.route.active_view.init_imagine()

	render: ->
		@$el.html @template(@model.toJSON())
		this