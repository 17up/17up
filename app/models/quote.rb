class Quote < Text
  
  field :author, type: Hash
  field :source, type: Hash

  validates :content, :uniqueness => true,:presence => true
  validates :tags, :presence => true
  validates :author, :presence => true
  BASE_URL = "http://www.goodreads.com"
  TAG_KEY = "quote_tags"

  scope :no_tag, where(:tags => nil)
  scope :empty_tag, where(:tags.with_size => 0)
  scope :one_tag, where(:tags.with_size => 1)
  scope :with_author, where(:author.exists => true)
  scope :without_author, where(:author => nil)

  def self.tag_by(tag_list,match_any = true)
    if match_any
      Quote.any_in(:tags => tag_list.split(","))
    else
      Quote.all_in(:tags => tag_list.split(","))
    end
  end

  def self.author_by author_name
    Quote.where('author.name' => author_name)
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
  # 条件：出现过2次以上的tag
  def self.tags_list(conditions = {})
    if conditions[:clear]
      Rails.cache.clear(TAG_KEY)
    end
    list = Rails.cache.fetch(TAG_KEY) do
      tags = Quote.pluck(:tags).flatten
      Quote.tags.map{ |x| [x,tags.grep(x).length] }.sort{|a,b| b[1] <=> a[1]}
    end
    if conditions[:up]
      list.select{|x| x[1] > conditions[:up]}
    elsif conditions[:pop]
      list.delete list.select{|x| x[0] == conditions[:pop]}[0]
      Rails.cache.write(TAG_KEY,list)
    else
      list
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

  index({"author.name" => 1})
  index({ tags: 1})
end
