class Person
  include Mongoid::Document
  field :name, type: String
  field :tags, type: Array
  field :area
  field :glist, type: Array

  validates :name, :presence => true,:uniqueness => true

  def like_by?(member)
    glist.include?(member._id) if glist
  end
 
  rails_admin do 
  	field :name
  	field :tags do
      pretty_value do
        value.blank? ? '-' : value.join(" / ")
      end
    end
    field :area
  end

  index({ name: 1})
  index({ tags: 1})
end
