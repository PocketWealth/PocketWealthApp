class StockQueryService
  require "json"
  include Http
  def initialize(stock_client)
    @stock_client = stock_client
  end

  def stock_price(stock_identifier)
    @stock_client.get_stock_price(stock_identifier)
  end
end
