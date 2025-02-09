if Rails.env.production?
  Geocoder.configure(
    always_raise: :all,
    lookup: :amazon_location_service,
    amazon_location_service: {
      index_name: "hackathons",
      api_key: {
        region: Rails.application.credentials.dig(:aws, :region),
        access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
        secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key)
      }
    }
  )
end
