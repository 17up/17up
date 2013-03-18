class window.Olive.QuotesView extends Olive.View
	id: 'quotes'
	template: JST['quotes_view']
	model: new Olive.Quote()
	destroy_tag: ->
		$wrap = $("#tag_list",$("#" + @id))
		$form = $("form",$wrap)	
		$form.bind 'ajax:success', (d,data) ->
			if data.status is 0
				$form[0].reset()
				Utils.flash("#{data.data} removed")
		$wrap.on "click",".as_link", ->
			tag_name = $.trim $(@).text()
			$ele = $(@).parent()
			Utils.confirm "确认删除？", ->
				$.post "/olive/destroy_tag",tag: tag_name, (d) ->
					if d.status is 0
						$ele.remove()
						Utils.flash("#{d.data} removed")
	create: ->
		$wrap = $("#create",$("#" + @id))
		$form = $("form",$wrap)	
		$form.bind 'ajax:before',(d) ->
			Utils.loading $wrap
		$form.bind 'ajax:success', (d,data) ->
			if data.status is 0		
				Utils.flash(data.msg)
				$form[0].reset()
				Utils.loaded $wrap

	search: ->
		$wrap = $("#search",$("#" + @id))
		$form = $("form",$wrap)	
		$form.bind 'ajax:before',(d) ->
			Utils.loading $wrap
		$form.bind 'ajax:success', (d,data) ->
			$query = $("input[type='text']",$form).val()
			if data.status is 0		
				$("#quote_list").html JST['collection/quotes'](quotes: data.data.quotes,query: $query)
				$form[0].reset()
				Utils.loaded $wrap
	render: ->
		template = @template(tags: @model.get('tags'))
		$(@el).append(template)			
		@destroy_tag()
		@active()
		@create()
		@search()
		this