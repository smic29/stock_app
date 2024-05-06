require 'json'

class Memegen::Response
  def self.parse_keyword_results(response)
    parsed_response = JSON.parse(response.body)

    parsed_response.sample['url']
  end
end
