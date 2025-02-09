class Loops::Resource
  BASE_URL = "https://app.loops.so/api/v1/"
  ENDPOINT = ""

  class << self
    def create(**)
      new(**).create
    end

    def connection
      @connection ||= Faraday.new(BASE_URL) do |faraday|
        faraday.request :authorization, "Bearer", Rails.application.credentials.loops_api_key
        faraday.request :json
        faraday.response :json
        faraday.response :raise_error
      end
    end
  end

  def initialize(**attributes)
    @attributes = attributes
  end

  def create
    self.class.connection.post(self.class::ENDPOINT + "create", attributes)
  end

  def save
    self.class.connection.put(self.class::ENDPOINT + "update", attributes)
  end

  private

  attr_reader :attributes

  def respond_to_missing?(_, _)
    true
  end

  def method_missing(name, *args)
    if name.to_s.end_with?("=")
      attributes[name.to_s.delete("=").to_sym] = args.first
    else
      attributes[name.to_sym]
    end
  end
end
