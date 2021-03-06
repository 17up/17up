class Word
  include Mongoid::Document

  field :title
  field :content,localize: true
  field :lang
  field :synset, type: Array, default: []
  field :sentence, type: Array, default: []

  has_many :u_words
  
  scope :en,where(:lang => nil)

  validates :title, :presence => true, :uniqueness => true
  IMAGE_URL = "/system/images/word/"
  IMAGE_PATH = "#{Rails.root}/public"+IMAGE_URL
  after_create :draw

  def source_voice
    $dict_source[:english_v] + URI.encode(self.title)
  end

  # draw word
  def image_path
    IMAGE_PATH + self.title.parameterize.underscore + "/w.png" 
  end

  def image_url
    IMAGE_URL + self.title.parameterize.underscore + "/w.png"
  end

  def draw
    dir = IMAGE_PATH + self.title.parameterize.underscore
    unless File.exist?(dir)
        `mkdir -p #{dir}`
    end
    opts = {
      :text => title,
      :type => 2,
      :word_path => image_path
    }
    Image::Convert.draw_word(opts)
  end

  def as_json
    super(:only => [:_id,:title,:content])
  end

  rails_admin do
    field :title
    field :content do
      pretty_value do
        value["#{I18n.locale.to_s}"] 
      end
    end
  end

  index({ title: 1})
end
