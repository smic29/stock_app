class Memegen::Resources::Images
  def initialize(client)
    @client = client
  end

  # keyword can be whatever
  def custom(keyword)
    response = @client.get('images/custom', filter: sanitize_string(keyword))

    response.data.is_a?(Hash) ? generate(template_id: 'fry', text: ['not sure if it exists', 'or code is bad']) : response.data.sample['url']
  end

  # needs template_id: and text: []
  def generate(settings = {})
    response = @client.post('images', settings)
    response.data['url']
  end

  private

  def sanitize_string(keyword)
    keyword.strip.gsub(' ', "_")
  end

end
