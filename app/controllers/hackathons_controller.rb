class HackathonsController < ApplicationController
  skip_before_action :redirect_if_unauthenticated

  def index
    if Current.user&.admin?
      redirect_to admin_hackathons_path
    else
      redirect_to Hackathons::WEBSITE, allow_other_host: true
    end
  end
end
