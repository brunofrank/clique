json.extract! comment, :id, :content, :created_by_id, :reply_to_id, :created_at, :updated_at
json.url comment_url(comment, format: :json)
