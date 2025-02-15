module StocksHelper

  def get_stock_price(symbol_id)
    begin
      api_key = get_questrade_api_key
      questrade_api_key_refresher = ApiKeyRefresherFactory.for(:questrade, api_key)
      questrade_stock_client = StockClientFactory.for(:questrade, api_key, questrade_api_key_refresher)
      stock_query_service = StockQueryService.new(questrade_stock_client)
      stock_query_service.stock_price(symbol_id)
    rescue Exception => e
      puts e
      flash[:error] = "ERROR!"
    end
  end
end
