# frozen_string_literal: true

class GroupItemComponent < ApplicationComponent
  with_collection_parameter :group

  def initialize(group:, current_user:)
    @group = group
    @current_user = current_user
  end
end
