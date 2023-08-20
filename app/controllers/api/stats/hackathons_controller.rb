class Api::Stats::HackathonsController < Api::BaseController
  def index
    @hackathons = Hackathon
  end
end
