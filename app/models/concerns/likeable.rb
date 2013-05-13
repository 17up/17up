module Concerns
  module Likeable
    extend ActiveSupport::Concern

    included do
      field :liked_member_ids, :type => Array, :default => []
    end

    def liked_by?(member)
      return false if member.blank?
      self.liked_member_ids.include?(member._id)
    end
  end
end