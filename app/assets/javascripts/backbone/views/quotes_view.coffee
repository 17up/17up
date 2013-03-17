#= require ../templates/quotes_view
#= require ../models/quote

class window.Olive.QuotesView extends Backbone.View
	id: ''
	template: JST['backbone/templates/quotes_view']
	el: 'article'
	model: new Olive.Quote()
	initialize: ->
		self = this
		@model.fetch
			success: ->
				self.render()
	active: ->
		$("#side_nav li[rel='" + @id + "']").addClass('active').siblings().removeClass("active")
	destroy_tag: ->
		$wrap = $("#tag_list")
		$btn = $(".form .btn",$wrap)
		$input = $(".form input[name='tag']",$wrap)
		$btn.click ->
			$.post "/olive/destroy_tag",tag: $input.val(), (d) ->
				if d.status is 0
					$input.val("")
					Utils.flash("#{d.data} removed")
		$wrap.on "click",".as_link", ->
			tag_name = $.trim $(@).text()
			$ele = $(@).parent()
			Utils.confirm "确认删除？", ->
				$.post "/olive/destroy_tag",tag: tag_name, (d) ->
					if d.status is 0
						$ele.remove()
						Utils.flash("#{d.data} removed")
	render: ->
		template = @template(tags: @model.get('tags'),quotes: @model.get('quotes'))
		$(@el).append(template)			
		@destroy_tag()
		@active()
		this