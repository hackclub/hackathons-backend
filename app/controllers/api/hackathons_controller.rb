class Api::HackathonsController < ApiController
  include ::Pagination

  def index
    @hackathons = paginate Hackathon.approved
  end

  def show
    @hackathon = Hackathon.approved.find_by_hashid!(params[:id])
  end
end
