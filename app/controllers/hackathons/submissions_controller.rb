class Hackathons::SubmissionsController < ApplicationController
  def index
    @hackathons = Hackathon.not_approved.where applicant: Current.user

    redirect_to new_hackathons_request_path if @hackathons.none?
  end

  def new
    @hackathon = Hackathon.new
  end

  def create
    @hackathon = Hackathon.new(hackathon_params)
    if @hackathon.save context: :submit
      redirect_to hackathons_requests_path, notice: "Your hackathon has been submitted for approval!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @hackathon = Hackathon.not_approved.where(applicant: Current.user).find(params[:id])
  end

  private

  def hackathon_params
    params.require(:hackathon).permit(
      :name,
      :website,
      :logo,
      :banner,
      :starts_at,
      :ends_at,
      :address,
      :expected_attendees
    )
  end
end
