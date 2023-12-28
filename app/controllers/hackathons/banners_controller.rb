class Hackathons::BannersController < ApplicationController
  include ActiveStorage::Streaming
  include HackathonScoped

  def show
    http_cache_forever(public: true) do
      send_blob_stream @hackathon.banner.variant(:large)
    end
  end
end
