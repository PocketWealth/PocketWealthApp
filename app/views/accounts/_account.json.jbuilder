json.extract! account, :id, :name, :account_type, :cash, :description, :financial_institution, :created_at, :updated_at
json.url account_url(account, format: :json)
