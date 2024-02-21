class Hackathons::SubmissionsController < ApplicationController
  skip_before_action :redirect_if_unauthenticated, only: [:new, :create]

  def index
    @hackathons = Hackathon.not_approved.where applicant: Current.user

    redirect_to new_hackathons_submission_path if @hackathons.none?
  end

  def new
    @hackathon = Hackathon.new
    @hackathon.build_swag_mailing_address
  end

  def create
    offers_financial_assistance = params[:hackathon][:offers_financial_assistance] == "true"

    @hackathon = Hackathon.new(hackathon_params)

    @hackathon.tag_with! "Offers Financial Assistance" if offers_financial_assistance

    @hackathon.applicant = User.find_or_initialize_by(email_address: applicant_params[:email_address]) do |user|
      user.attributes = applicant_params
    end

    if @hackathon.save context: :submit
      @hackathon.logo.attach(hackathon_params[:logo])
      @hackathon.banner.attach(hackathon_params[:banner])
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
      :high_school_led
    )
  end

  def applicant_params
    params.require(:hackathon).require(:applicant).permit(
      :name,
      :email_address
    )
  end
end
