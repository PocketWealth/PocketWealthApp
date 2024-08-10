class StockQueryService
  include Http
  STOCKS_API_KEY = Rails.application.credentials.stocks_api_key
  STOCK_PRICE_PATH_BASE = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=%s&apikey=#{STOCKS_API_KEY}"
  def stock_price(symbol)
    url = STOCK_PRICE_PATH_BASE % [ symbol ]
    response_body = make_api_call(url)
    json = JSON.parse(response_body)
    json["Global Quote"]["05. price"]
  end
end
