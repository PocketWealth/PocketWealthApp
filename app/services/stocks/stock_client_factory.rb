class StockClientFactory
  TYPES = {
    questrade: QuestradeStockClient
  }

  def self.for(type, api_key, api_key_refresher)
    (TYPES[type]).new(api_key, api_key_refresher)
  end
end