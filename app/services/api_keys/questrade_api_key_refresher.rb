class QuestradeApiKeyRefresher
  require "json"
  include ApiKeyRefresher

  REFRESH_URL = "https://login.questrade.com/oauth2/token?grant_type=refresh_token&refresh_token=".freeze

  def initialize(api_key)
    @api_key = api_key
  end

  def refresh_api_key
    refresh_token = @api_key.refresh_token
    if refresh_token.nil?
      raise "refresh token was nil, cannot refresh questrade token"
    end
    url = "#{REFRESH_URL}#{refresh_token}"
    # Response is of the form
    # {
    #   "access_token": "SOME_TOKEN",
    #   "api_server": "https:\/\/api02.iq.questrade.com\/",
    #   "expires_in": 1800,
    #   "refresh_token": "SOME_TOKEN",
    #   "token_type": "Bearer"
    # }
    response_raw = make_get_api_call(url)
    api_key_params = parse_response(response_raw)
    @api_key.update(api_key_params)
    raise "Error updating API key with params #{api_key_params}" unless @api_key.valid?
    @api_key
  end

  def parse_response(response_raw)
    response_json = JSON.parse(response_raw)
    access_token = response_json["access_token"]
    refresh_token = response_json["refresh_token"]
    api_server = response_json["api_server"]
    validate_not_empty(access_token, refresh_token, api_server)
    {
      access_token: access_token,
      url: api_server,
      refresh_token: refresh_token
    }
  end
end
