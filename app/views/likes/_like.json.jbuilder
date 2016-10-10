json.extract! like, :id, :session_id, :image_id, :is_like, :created_at, :updated_at
json.url like_url(like, format: :json)