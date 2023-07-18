Hashid::Rails.configure do |config|
  # The salt to use for generating hashid. Prepended with pepper (table name).
  config.salt = Rails.application.credentials.dig(:hashid, :salt)

  # The minimum length of generated hashids
  config.min_hash_length = 6
end
