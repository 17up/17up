class Course
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  field :status, type: Integer, default: 3
  
  embeds_many :paragraphs
  accepts_nested_attributes_for :paragraphs
  # author
  belongs_to :member

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

  rails_admin do
    field :status, :integer do
      pretty_value do
        STATUS[value.to_s]
      end
    end
    field :member
  end

end
