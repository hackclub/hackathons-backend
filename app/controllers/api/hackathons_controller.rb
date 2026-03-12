class Api::HackathonsController < Api::BaseController
  def index
    set_page_and_extract_portion_from Hackathon.approved,
      ordered_by: {id: :desc}, per_page: 50
  end

  def show
    @hackathon = Hackathon.approved.find_by_hashid!(params[:id])
  end
end
