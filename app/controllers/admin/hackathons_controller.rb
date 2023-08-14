class Admin::HackathonsController < Admin::BaseController
  before_action :set_hackathon, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @hackathons = pagy(Hackathon.all.order(created_at: :desc))
  end

  def show
  end

  def edit
  end

  def update
    if @hackathon.update(hackathon_params)
      redirect_to admin_hackathon_path(@hackathon)
    else
      render :edit, status: :unprocessable_entity, notice: @hackathon.errors.full_messages.to_sentence
    end
  end

  def destroy
    if @hackathon.destroy
      redirect_to admin_hackathons_path, notice: "#{@hackathon.name} has been deleted."
    else
      render :show, status: :unprocessable_entity, notice: @hackathon.errors.full_messages.first
    end
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
        :name,
        :email_address
      ]
    )
  end

  def set_hackathon
    @hackathon = Hackathon.find(params[:id])
  end
end
