require 'rails_helper'

RSpec.describe "comments/new", type: :view do
  before(:each) do
    assign(:comment, Comment.new(
      content: "MyText",
      created_by: nil,
      reply_to: nil
    ))
  end

  it "renders new comment form" do
    render

    assert_select "form[action=?][method=?]", comments_path, "post" do

      assert_select "textarea[name=?]", "comment[content]"

      assert_select "input[name=?]", "comment[created_by_id]"

      assert_select "input[name=?]", "comment[reply_to_id]"
    end
  end
end
