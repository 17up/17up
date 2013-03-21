class window.Veggie.AccountView extends Veggie.View	
	id: "account"
	template: JST['account_view']
	collection: new Veggie.Account()	
	close: ->
		if $("#" + @id).jmpress("initialized")
			$("#" + @id).jmpress "deinit"
		super()
		# invoke super close method
	active: ->
		# 调用父类的active方法 
		# 等同于 Veggie.View.prototype.active.apply(this, arguments)
		super() 
		@init_jmpress()
	init_jmpress: ($ele = $("#" + @id)) ->
		#Utils.active_tab $(".step.active").attr("id")
		$ele.jmpress
			transitionDuration: 0
			hash:
				use: true
			mouse:
				clickSelects: false
			keyboard:
				keys:
					9: null
					32: null
		$(".step",$ele).on 'enterStep', (e) ->
			#Utils.active_tab $(e.target).attr("id")
	render: ->
		template = @template
			providers: @collection.get("providers")
		@$el.append(template)		
		@active()		
		this