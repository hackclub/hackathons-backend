Rails.application.configure do
  aws = Rails.application.credentials.aws

  config.litestream.replica_bucket = aws&.bucket
  config.litestream.replica_key_id = aws&.access_key_id
  config.litestream.replica_access_key = aws&.secret_access_key
end
