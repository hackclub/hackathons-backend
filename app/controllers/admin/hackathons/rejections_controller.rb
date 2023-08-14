class Admin::Hackathons::RejectionsController < Admin::BaseController
  include HackathonScoped

  def create
    @hackathon.reject
    redirect_to admin_hackathon_path(@hackathon)
  end
end
