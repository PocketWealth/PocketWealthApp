json.extract! user, :id, :name, :email, :admin, :password_digest, :remember_digest, :created_at, :updated_at
json.url user_url(user, format: :json)
