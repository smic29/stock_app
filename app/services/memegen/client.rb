require 'net/http'

class Memegen::Client
  CONFIG = Memegen::Configuration.new

  def fetch_keyword_meme(keyword)
    kw_without_spaces = keyword.gsub(' ', "_")
    uri = build_uri('images/custom', filter: kw_without_spaces)
    response = http_request(uri)

    Memegen::Response.parse_keyword_results(response)
  end

  private

  def build_uri(endpoint, params = {})
    uri = URI.join(CONFIG.base_url, endpoint)
    uri.query = URI.encode_www_form(params) unless params.empty?

    uri
  end

  def http_request(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 10

    request = Net::HTTP::Get.new(uri)

    http.request(request)
  end
end
