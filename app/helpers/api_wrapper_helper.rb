module ApiWrapperHelper
  def memegen_client
    @client ||= Memegen::Client.new
  end

  def memegen_images
    @images ||= Memegen::Resources::Images.new(memegen_client)
  end

  def memegen_templates
    @templates ||= Memegen::Resources::Templates.new(memegen_client)
  end
end
