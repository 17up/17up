class Text
  include Mongoid::Document

  field :language
  field :content
  field :tags, type: Array

  scope :en,where(:language => nil)

end
