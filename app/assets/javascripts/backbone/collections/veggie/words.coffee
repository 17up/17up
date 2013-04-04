class window.Veggie.Words extends Backbone.Collection
	model: Word
	addOneWord: (word,opts = {}) ->
		options = _.extend
			model: word
			opts
		view = new Veggie.WordView options			 
		new_step = view.render().el
		$("#imagine").append(new_step)
		# $("#imagine").jmpress("canvas").append(new_step)
		# $("#imagine").jmpress("init",new_step)
	push: (word,opts = {}) ->
		super(word)
		@addOneWord(word,opts)