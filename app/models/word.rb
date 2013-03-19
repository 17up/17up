class Word
  include Mongoid::Document

  field :title
  field :content,localize: true
  field :lang

  scope :en,where(:lang => nil)

  validates :title, :presence => true, :uniqueness => true
  IMAGE_URL = "/system/images/word/"
  IMAGE_PATH = "#{Rails.root}/public"+IMAGE_URL

  def source_voice
    $dict_source[:english_v] + URI.encode(self.title)
  end

  # style: 17up/original
  def image_path(opt={})
    name = opt[:w] ? "/w.png" : "/#{$config[:name]}.jpg"
    IMAGE_PATH + self.title.parameterize.underscore + name
  end

  def image_url(opt={})
    if opt[:w]
      name = "/w.png"
    elsif opt[:o]
      name = "/original.jpg"
    else
      name = "/#{$config[:name]}.jpg"
    end
    IMAGE_URL + self.title.parameterize.underscore + name
  end

  def image
    return File.exist?(self.image_path) ? self.image_url : "/assets/icon/default.png"
  end

  rails_admin do
    field :title
    field :content do
      pretty_value do
        value["#{I18n.locale.to_s}"] 
      end
    end
  end
end
