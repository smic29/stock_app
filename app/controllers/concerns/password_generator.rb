module PasswordGenerator
  extend ActiveSupport::Concern

  def generate_random_password(min_length = 6)
    characters = [('a'..'z'), ('A'..'Z'), (0..9)].map(&:to_a).flatten
    password = ''

    min_length.times { password << characters.sample.to_s }

    password
  end
end
