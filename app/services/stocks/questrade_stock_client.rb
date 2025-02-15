class QuestradeStockClient
  include StockClient
  include Http
  MAX_ATTEMPTS = 3.freeze
  STOCK_PRICE_PATH_SUFFIX = "v1/markets/quotes".freeze
  STOCK_SEARCH_PATH_SUFFIX = "v1/symbols/search".freeze

  def initialize(api_key, api_key_refresher)
    @api_key = api_key
    @api_key_refresher = api_key_refresher
    @redis_service = RedisService.new
  end

  def get_stock_price(stock_identifier)
    cached_value = @redis_service.get_hash("stock:#{stock_identifier}:data", "price")
    return cached_value if cached_value
    stock_symbol_id = get_stock_id(stock_identifier)
    url = get_stock_price_url stock_symbol_id
    response_body = make_questrade_api_call(url)
    stock_price = get_stock_price_from_response(response_body)
    @redis_service.set_hash("stock:#{stock_identifier}:data", "price", stock_price, expires_in: 5.minutes)
    stock_price
  end

  def get_stock_id(stock_identifier)
    cached_value = @redis_service.get_hash("stock:#{stock_identifier}:metadata", "symbol_id")
    return cached_value if cached_value
    url = get_stock_search_url stock_identifier
    response_body = make_questrade_api_call(url)
    stock_id = get_symbol_id_from_response(response_body)
    raise "Unable to find stock with identifier #{stock_identifier}" if stock_id.blank?
    @redis_service.set_hash("stock:#{stock_identifier}:metadata", "symbol_id", stock_id)
    stock_id
  end

  def make_questrade_api_call(url)
    attempts = 0
    while attempts < MAX_ATTEMPTS
      begin
        response_body = make_authenticated_get_api_call(url, @api_key.access_token)
        return response_body
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
    raise "Unable to make API request, exhausted all attempts to refresh key"
  end

  private

  def get_stock_price_from_response(raw_response)
    data = JSON.parse(raw_response)
    quotes = data["quotes"]
    stock_quote = quotes[0]
    raise "Stock symbol missing from quote, assuming a bad request" if stock_quote.blank?
    stock_quote["lastTradePriceTrHrs"]
  end

  def get_symbol_id_from_response(raw_response)
    data = JSON.parse(raw_response)
    stocks = data["symbols"]
    return nil if stocks.empty?
    stock = stocks[0]
    stock["symbolId"]
  end

  def get_stock_price_url(stock_identifier)
    "#{@api_key.url}#{STOCK_PRICE_PATH_SUFFIX}/#{stock_identifier}"
  end

  def get_stock_search_url(stock_identifier)
    "#{@api_key.url}#{STOCK_SEARCH_PATH_SUFFIX}?prefix=#{stock_identifier}"
  end
end
