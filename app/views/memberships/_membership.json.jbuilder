json.extract! membership, :id, :user_id, :group_id, :status, :created_at, :updated_at
json.url membership_url(membership, format: :json)
