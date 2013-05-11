class Invite
  include Mongoid::Document

  field :target
  field :provider

  belongs_to :member
  validates :target, :uniqueness => {:scope => [:member_id,:provider]},:presence => true

  scope :weibo, -> {where(:provider => 'weibo')}
end
