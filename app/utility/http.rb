module Http
  def make_api_call(url)
    response = Faraday.get(url)
    response.body
  end
end
