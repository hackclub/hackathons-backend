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
    @hackathon = Hackathon.new(
      hackathon_params.except(:applicant, :offers_financial_assistance, :requested_swag)
    )

    if hackathon_params[:requested_swag] == "0"
      @hackathon.swag_mailing_address = nil
    end

    if @hackathon.save context: :submit
      if hackathon_params[:offers_financial_assistance]
        @hackathon.tag_with! "Offers Financial Assistance"
      end

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
      :address,
      :expected_attendees,
      :offers_financial_assistance,
      :requested_swag,
      swag_mailing_address_attributes: [
        :line1,
        :line2,
        :city,
        :province,
        :postal_code,
        :country_code
      ],
      applicant: [
        :email_address
      ]
    )
  end
end
