class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :created_by, class_name: 'User'
  belongs_to :reply_to, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: :reply_to_id
end
