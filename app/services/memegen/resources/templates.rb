class Memegen::Resources::Templates
  def initialize(client)
    @client = client
  end

  def templates
    response = @client.get('templates')

    response.data
  end

end
