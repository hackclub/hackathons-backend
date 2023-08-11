class Admin::Hackathons::ApprovalsController < Admin::BaseController
  include HackathonScoped

  def create
    @hackathon.approve
    redirect_to admin_hackathon_path(@hackathon)
  end
end
