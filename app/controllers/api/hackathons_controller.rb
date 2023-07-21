class Api::HackathonsController < ApiController
  def index
    @hackathons = Hackathon.approved
  end

  def show
    @hackathon = Hackathon.approved.find_by_hashid!(params[:id])
  end
end
