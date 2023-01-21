require 'jwt'

module JsonWebToken
  extend ActiveSupport::Concern
  SECRET_KEY = Rails.application.secret_key_base

  # def jwt_encode(payload, exp = 7.days.from_now)
  #   puts 'NARRATION: JWT ENCODING'
  #   JWT.encode(payload, SECRET_KEY, 'HS256')
  # end

  def jwt_decode(token)
    puts 'NARRATION: JWT DECODING'
    token_itself = token.split(' ')[1]
    decoded = JWT.decode(token_itself, SECRET_KEY, true, { algorithm: 'HS256' })
    decoded
  end
end
