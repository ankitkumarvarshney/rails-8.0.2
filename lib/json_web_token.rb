class JsonWebToken
  # Use a more secure way to load the secret key
  SECRET_KEY = ENV["JWT_SECRET_KEY"] || Rails.application.credentials.secret_key_base

  ALGORITHM = "HS512"

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  def self.decode(token)
    decoded_token = JWT.decode(token, SECRET_KEY, true, { algorithm: ALGORITHM })[0]
    HashWithIndifferentAccess.new(decoded_token)
  rescue JWT::ExpiredSignature
    Rails.logger.warn "JWT expired"
    nil
  rescue JWT::VerificationError, JWT::DecodeError => e
    Rails.logger.warn "JWT Decode error: #{e.message}"
    nil
  end
end
