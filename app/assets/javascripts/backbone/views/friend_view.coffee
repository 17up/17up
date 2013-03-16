#= require ./veggie_view
#= require ../models/friend
#= require ../templates/friend_view

class window.Veggie.FriendView extends Veggie.View
	id: "friend"
	template: JST['backbone/templates/friend_view']
	model: new Veggie.Friend()
	render: ->
		template = @template(friend: @model)
		$(@el).append(template)
		@active()
		this