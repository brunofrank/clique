class Group < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_and_belongs_to_many :members, class_name: "User"
  has_many :posts, dependent: :delete_all

  scope :created_by, ->(user) { where(owner: user) }
  scope :is_member, ->(user) { joins(:members).where("groups_users.user_id = ?", user.id) }

  def member?(user)
    members.where("groups_users.user_id = ?", user.id).count.positive?
  end

  def last_activity
    @last_activity ||= [
      posts.order("created_at ASC").last&.created_at,
      Comment.where(post_id: posts.pluck(:id)).order("created_at ASC").last&.created_at
    ].compact.max
  end
end
