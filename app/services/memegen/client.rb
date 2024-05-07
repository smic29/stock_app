require 'net/http'

class Memegen::Client
  def initialize
    @config = Memegen::Configuration.new
  end

  def get(path, params = {})
    uri = params.empty? ? build_uri(path) : build_uri(path, params)
    response = http_request(uri)

    Memegen::Response.new(response)
  end

  def post(path, data)
    uri = build_uri(path)

    response = http_request(uri, data)

    Memegen::Response.new(response)
  end

  private

  def build_uri(path, params = {})
    uri = URI.join(@config.base_url, path)
    uri.query = URI.encode_www_form(params) unless params.empty?

    uri
  end

  def http_request(uri, body = nil)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 10

    request = body.nil? ? Net::HTTP::Get.new(uri) : Net::HTTP::Post.new(uri)
    request.body = body.to_json unless body.nil?

    http.request(request)
  end
end
