class InternetArchive
  # Uses the SPN2 (Save Page Now 2) API
  # https://docs.google.com/document/d/1Nsv52MvSjbLb2PCpHlat0gkzw0EvtSgpKHu4mk0MnrA/edit
  include Singleton

  BASE_URL = "https://web.archive.org/"
  attr_accessor :access_key, :access_secret

  def capture(url)
    connection.post("save", "url=#{url}").body
  end

  def status(job_id)
    connection.get("save/status/#{job_id}").body
  end

  private

  def connection
    @connection ||= Faraday.new(BASE_URL, headers:) do |faraday|
      faraday.response :json
    end
  end

  def headers
    {
      Accept: "application/json"
    }.deep_merge auth_header
  end

  def auth_header
    {
      Authorization: "LOW #{access_key}:#{access_secret}"
    }
  end
end

InternetArchive.instance.tap do |config|
  config.access_key = Rails.application.credentials.dig(:internet_archive, :access_key)
  config.access_secret = Rails.application.credentials.dig(:internet_archive, :access_secret)
end
