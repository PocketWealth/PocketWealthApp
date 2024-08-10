module StocksHelper
  def stock_information(symbol)
    StockQueryService.new.stock_price(symbol)
  end
end
