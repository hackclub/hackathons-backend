class Api::HackathonsController < Api::BaseController
  def index
    @pagy, @hackathons = pagy(Hackathon.approved.with_attached_logo.with_attached_banner)
  end

  def show
    @hackathon = Hackathon.approved.find_by_hashid!(params[:id])
  end
end
