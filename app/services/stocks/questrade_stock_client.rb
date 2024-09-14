class QuestradeStockClient
  include StockClient
  include Http
  MAX_ATTEMPTS = 3.freeze
  STOCK_PRICE_PATH_SUFFIX = "v1/markets/quotes".freeze

  def initialize(api_key, api_key_refresher)
    @api_key = api_key
    @api_key_refresher = api_key_refresher
  end

  def get_stock_price(stock_identifier)
    attempts = 0
    while attempts < MAX_ATTEMPTS
      begin
        url = get_stock_price_url stock_identifier
        response_body = make_authenticated_get_api_call(url, @api_key.access_token)
        return get_stock_price_from_response(response_body)
        # Refresh the token and try again
      rescue Faraday::UnauthorizedError => e
        @api_key = @api_key_refresher.refresh_api_key
        @api_key.reload
      rescue => e
        puts e
      ensure
        attempts += 1
      end
    end
    raise "Unable to get stock price, exhausted all attempts to refresh key"
  end

  private

  def get_stock_price_from_response(raw_response)
    data = JSON.parse(raw_response)
    quotes = data["quotes"]
    stock_quote = quotes[0]
    stock_quote["lastTradePriceTrHrs"]
  end

  def get_stock_price_url(stock_identifier)
    "#{@api_key.url}#{STOCK_PRICE_PATH_SUFFIX}/#{stock_identifier}"
  end
end
