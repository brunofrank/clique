# frozen_string_literal: true

class CommentItemComponent < ApplicationComponent
  with_collection_parameter :comment

  def initialize(comment:, current_user:)
    @comment, = comment,
    @current_user = current_user
  end
end
