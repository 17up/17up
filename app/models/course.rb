class Course
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  field :title
  field :lang
  field :status, type: Integer, default: 3
  field :tags, type: Array
  
  
  # author
  belongs_to :member

  scope :en,where(:lang => nil)

  STATUS = {
    "1" => "open",
    "2" => "ready",
    "3" => "draft"
  }
  # 1 : 发布状态 不能被修改，否则变为 3
  # 2 : 审核状态 不能修改，－>1 ->3
  # 3 : 草稿状态 默认
  STATUS.each do |k,v|
    scope v.to_sym,where(:status => k.to_i)
  end


  def check(member,wids)
    
  end

  def as_json
    ext = {
      "author" => member.name,
      "status" => STATUS[status.to_s]
    }
    super(:only => [:title]).merge(ext)
  end

  rails_admin do
    field :status, :integer do
      pretty_value do
        STATUS[value.to_s]
      end
    end
    field :title
    field :member
  end

end
