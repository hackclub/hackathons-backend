class Admin::Hackathons::HoldsController < Admin::BaseController
  include HackathonScoped

  def create
    @hackathon.hold
    redirect_to admin_hackathon_path(@hackathon)
  end
end
