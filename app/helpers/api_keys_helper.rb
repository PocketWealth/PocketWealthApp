module ApiKeysHelper
  def get_questrade_api_key
    api_key = get_api_key "questrade"
    raise error "Questrade API key was not found" if api_key.nil?
    api_key
  end


  private
    def get_api_keys
      user = current_user
      user.api_keys
    end

    def get_api_key(provider)
      api_keys = get_api_keys
      api_keys.find_by(provider: provider.downcase)
    end
end
