# Uses the Save Page Now 2 API
# (https://docs.google.com/document/d/1Nsv52MvSjbLb2PCpHlat0gkzw0EvtSgpKHu4mk0MnrA)
class InternetArchive::Capture
  attr_reader :website_url, :job_id

  def initialize(website_url: nil, job_id: nil)
    @website_url = website_url
    @job_id = job_id
  end

  def request
    response = connection.post("save", "url=#{website_url}").body
    @job_id = response["job_id"]
    response
  end

  def finished?
    status == "success"
  end

  private

  BASE_URL = "https://web.archive.org/"

  def status
    connection.get("save/status/#{job_id}").body&.dig("status")
  end

  def connection
    @connection ||= Faraday.new(BASE_URL, headers:) do |faraday|
      faraday.response :json
      faraday.response :raise_error
    end
  end

  def headers
    {
      Accept: "application/json",
      Authorization: "LOW #{access_key}:#{access_secret}"
    }
  end

  def access_key
    Rails.application.credentials.dig(:internet_archive, :access_key)
  end

  def access_secret
    Rails.application.credentials.dig(:internet_archive, :access_secret)
  end
end
