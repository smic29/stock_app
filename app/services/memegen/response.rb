require 'json'

class Memegen::Response
  attr_reader :raw_response

  def initialize(response)
    @raw_response = response
  end

  def success?
    raw_response.code == '200'
  end

  def data
    JSON.parse(raw_response.body)
  end

end
