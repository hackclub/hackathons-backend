class HackathonsController < ApplicationController
  allow_unauthenticated_access

  def index
    if Current.user&.admin?
      redirect_to admin_hackathons_path
    else
      redirect_to Hackathons::WEBSITE, allow_other_host: true
    end
  end
end
