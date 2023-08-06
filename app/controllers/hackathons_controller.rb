class HackathonsController < ApplicationController
  skip_before_action :redirect_if_unauthenticated

  def index
    redirect_to "https://hackathons.hackclub.com", allow_other_host: true
  end
end
