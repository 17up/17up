class Quote < Text
  
  field :author, type: Hash
  field :source, type: Hash

  validates :content, :uniqueness => true,:presence => true
  BASE_URL = "http://www.goodreads.com"

  scope :no_tag, where(:tags => nil)
  scope :empty_tag, where(:tags.with_size => 0)
  scope :one_tag, where(:tags.with_size => 1)
  scope :with_author, where(:author.exists => true)
  scope :without_author, where(:author => nil)

  def self.tag_by tag
    Quote.any_in(:tags => [tag])
  end

  # output array 947.William_Shakespeare
  def self.authors(quotes = Quote.all)
    #Quote.distinct(:author).collect{|x| x["link"].split("/")[3]}
    quotes.pluck(:author).collect{|x| x["link"].split("/")[3]}.uniq
  end

  # output array 
  def self.tags(quotes = Quote.all)
    quotes.pluck(:tags).flatten.uniq
  end

  # 2th array [tag,num]
  def self.tags_list
    Rails.cache.fetch("quote_tags") do
      tags = Quote.pluck(:tags).flatten
      Quote.tags.map{ |x| [x,tags.grep(x).length] }.sort{|a,b| b[1] <=> a[1]}
    end
  end

  rails_admin do 	
  	field :author do
      pretty_value do
        bindings[:view].link_to(value["name"],BASE_URL + value["link"])
      end
    end
  	field :content,:text do 
      pretty_value do
        bindings[:view].raw value
      end
    end
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
