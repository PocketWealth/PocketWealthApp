class ApiKeyRefresherFactory
  TYPES = {
    questrade: QuestradeApiKeyRefresher
  }

  def self.for(type, api_key)
    (TYPES[type]).new(api_key)
  end
end