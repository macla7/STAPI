json.extract! post, :id, :body, :user_id, :ends_at, :auction, :created_at, :updated_at
json.url post_url(post, format: :json)
