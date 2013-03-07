class Course
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  field :title, type: String
  field :status, type: Integer
  field :ctype, type: Integer
  field :language, type: String
  field :content, type: String
  field :tags, type: Array

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

  CTYPE = {
    "1" => "pro",
    "2" => "common"
  }
  # 1: 教师课程 限role=e/a
  # 2: 个人课程 
  CTYPE.each do |k,v|
    scope v.to_sym,where(:ctype => k.to_i)
  end

  def check(member,wids)
    
  end

end
