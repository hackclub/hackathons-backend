class Api::HackathonsController < Api::BaseController
  def index
    set_page_and_extract_portion_from(
      Hackathon.approved
               .includes(:tags, :events)
               .with_attached_logo.with_attached_banner,
      ordered_by: {id: :desc}, per_page: 100
    )
  end

  def show
    @hackathon = Hackathon.approved.find_by_hashid!(params[:id])
  end
end
