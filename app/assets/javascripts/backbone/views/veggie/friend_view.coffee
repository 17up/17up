class window.Veggie.FriendView extends Veggie.View
	id: "friend"
	template: JST['friend_view']
	model: new Veggie.Friend()
	render: ->
		template = @template(friend: @model)
		$(@el).append(template)
		@active()
		this