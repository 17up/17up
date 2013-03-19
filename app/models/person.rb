class Person
  include Mongoid::Document
  field :name, type: String
  field :tags, type: Array
  field :area

  validates :name, :presence => true,:uniqueness => true
 
  rails_admin do 
  	field :name
  	field :tags do
      pretty_value do
        value.blank? ? '-' : value.join(" / ")
      end
    end
  end

  index({ name: 1})
  index({ tags: 1})
end
