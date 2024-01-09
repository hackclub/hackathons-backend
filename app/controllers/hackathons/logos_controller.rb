class Hackathons::LogosController < ApplicationController
  include ActiveStorage::Streaming
  include HackathonScoped

  def show
    http_cache_forever(public: true) do
      send_blob_stream @hackathon.logo.variant(:small)
    end
  end
end
