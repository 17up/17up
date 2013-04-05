class window.Veggie.AccountView extends Veggie.View	
	id: "account"
	className: "jmpress"
	template: JST['account_view']
	collection: new Veggie.Account()
	close: ->
		if @$el.jmpress("initialized")
			@$el.jmpress "deinit"
		super()
		# invoke super close method
	active: ->
		# 调用父类的active方法 
		# 等同于 Veggie.View.prototype.active.apply(this, arguments)
		super() 
		@init_jmpress()
	init_jmpress: ->
		#Utils.active_tab $(".step.active").attr("id")
		@$el.jmpress
			transitionDuration: 0
			hash:
				use: true
			mouse:
				clickSelects: false
			keyboard:
				keys:
					9: null
					32: null
	addProviders: (providers) ->
		for p,i in providers
			provider = new Provider
				provider: p.provider
				num: i + 1
			view = new Veggie.ProviderView
				model: provider
			@$el.append(view.render().el)
	render: ->
		template = @template(@collection.toJSON())
		@$el.html(template)				
		this
	extra: ->
		providers = _.filter @collection.get("providers"),(p) ->
			p if p.has_bind
		@addProviders providers

		super()