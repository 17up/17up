class Quote < Text
  
  field :author, type: Hash
  field :source, type: Hash

  validates :content, :uniqueness => true
  BASE_URL = "http://www.goodreads.com"

  def self.tag_by tag
    Quote.any_in(:tags => [tag])
  end

  rails_admin do 	
  	field :author do
      pretty_value do
        bindings[:view].link_to(value["name"],BASE_URL + value["link"])
      end
    end
  	field :content,:text
  	field :tags do
      pretty_value do
        value.blank? ? '-' : value.join(" / ")
      end
    end
    field :source do
      pretty_value do
        unless value.blank?
          bindings[:view].link_to(value["name"],BASE_URL + value["link"])
        end
      end
    end
  end
end
