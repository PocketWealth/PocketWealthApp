json.extract! api_key, :id, :provider, :access_token, :refresh_token, :url, :created_at, :updated_at
json.url api_key_url(api_key, format: :json)
