module StocksHelper
  def get_stock_price(symbol_id)
    # stock_price = Rails.cache.read(symbol_id)
    # return stock_price unless stock_price.nil?
    # For now assume it's only questrade
    begin
      api_key = get_questrade_api_key
      questrade_api_key_refresher = ApiKeyRefresherFactory.for(:questrade, api_key)
      questrade_stock_client = StockClientFactory.for(:questrade, api_key, questrade_api_key_refresher)
      stock_query_service = StockQueryService.new(questrade_stock_client)
      stock_price = stock_query_service.stock_price(symbol_id)
      Rails.cache.write(symbol_id, stock_price, expires_in: 5.minutes)
      stock_price
    rescue 
      flash[:error] = "ERROR!"
    end
  end
end
