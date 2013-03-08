class Quote < Text
  
  field :author
  field :source

  rails_admin do
  	field :language
  	field :author
  	field :content
  	field :source
  	field :tags do
  		pretty_value do
  			value.join("/")
  		end
  	end
  end
end
