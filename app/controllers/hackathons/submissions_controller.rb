class Hackathons::SubmissionsController < ApplicationController
  skip_before_action :redirect_if_unauthenticated, only: %i[new create]

  def index
    @hackathons = Hackathon.not_approved.where applicant: Current.user

    redirect_to new_hackathons_submission_path if @hackathons.none?
  end

  def new
    @hackathon = Hackathon.new
    @hackathon.build_swag_mailing_address
  end

  def create
    requested_swag = params[:requested_swag] == "1"
    offers_financial_assistance = params[:hackathon][:offers_financial_assistance] == "true"

    @hackathon = Hackathon.new(hackathon_params)

    @hackathon.swag_mailing_address = nil unless requested_swag
    @hackathon.tag_with! "Offers Financial Assistance" if offers_financial_assistance

    @hackathon.applicant = User.find_or_initialize_by(email_address: applicant_params[:email_address]) do |user|
      user.attributes = applicant_params
    end

    if @hackathon.save context: :submit
      NotifyAdmins.call(hackathon_title: @hackathon.name)
      redirect_to new_hackathons_submission_path, notice: "Your hackathon has been submitted for approval!"
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
      :modality,
      # Location
      :street,
      :city,
      :province,
      :postal_code,
      :country_code,
      :expected_attendees,
      :high_school_led,
      # Swag
      swag_mailing_address_attributes: [
        :line1,
        :line2,
        :city,
        :province,
        :postal_code,
        :country_code
      ]
    )
  end

  def applicant_params
    params.require(:hackathon).require(:applicant).permit(
      :name,
      :email_address
    )
  end
end
