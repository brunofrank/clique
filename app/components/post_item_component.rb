# frozen_string_literal: true

class PostItemComponent < ApplicationComponent
  with_collection_parameter :post

  def initialize(post:, current_user:)
    @post = post
    @group = post.group
    @current_user = current_user
  end
end
