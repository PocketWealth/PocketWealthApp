json.extract! stock, :id, :symbol, :purchase_date, :share_price, :quantity_purchased, :created_at, :updated_at
json.url stock_url(stock, format: :json)
