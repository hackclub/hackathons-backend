class Hackathons::SubmissionsController < ApplicationController
  def index
    @hackathons = Hackathon.not_approved.where applicant: Current.user

    redirect_to new_hackathons_submission_path if @hackathons.none?
  end

  def new
    @hackathon = Hackathon.new
    @hackathon.build_swag_mailing_address
  end

  def create
    @hackathon = Hackathon.new(hackathon_params)
    if @hackathon.save context: :submit
      redirect_to hackathons_submissions_path, notice: "Your hackathon has been submitted for approval!"
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
      :expected_attendees,
      swag_mailing_address: [
        :line1,
        :line2,
        :city,
        :province,
        :postal_code,
        :country_code
      ]
    )
  end
end
