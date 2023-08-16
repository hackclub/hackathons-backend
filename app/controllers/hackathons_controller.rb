class HackathonsController < ApplicationController
  skip_before_action :redirect_if_unauthenticated

  def index
    redirect_to Hackathons::WEBSITE, allow_other_host: true
  end
end
