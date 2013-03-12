class Quote < Text
  
  field :author
  field :source
  field :html

  validates :content, :uniqueness => true

  def self.tag_by tag
    Quote.any_in(:tags => [tag])
  end

  rails_admin do 	
  	field :author
  	field :content	
  	field :tags do
      pretty_value do
        value.blank? ? '-' : value.join(" / ")
      end
    end
    field :source
    field :language
  end
end
