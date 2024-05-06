class Memegen::Configuration
  attr_accessor :api_key
  attr_reader :base_url

  def initialize
    @api_key = nil
    @base_url = 'https://api.memegen.link/'
  end
end
