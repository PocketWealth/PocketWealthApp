module ApiKeyRefresher
  include Http
  def refresh_api_key
    raise error "Method not implemented!"
  end


  def validate_not_empty(*strings)
    strings.each do |string|
      return false if string.empty?
    end
    true
  end
end