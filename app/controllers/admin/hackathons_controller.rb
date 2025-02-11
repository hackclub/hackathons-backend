class Admin::HackathonsController < Admin::BaseController
  before_action :set_hackathon, except: :index

  def index
    set_page_and_extract_portion_from Hackathon.all.with_attached_logo, ordered_by: {id: :desc}
  end

  def show
  end

  def edit
  end

  def update
    if @hackathon.update(hackathon_params)
      redirect_to admin_hackathon_path(@hackathon)
    else
      stream_flash_notice @hackathon.errors.full_messages.to_sentence
    end
  end

  def destroy
    if @hackathon.destroy
      redirect_to admin_hackathons_path, notice: "#{@hackathon.name} has been deleted."
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def hackathon_params
    params.require(:hackathon).permit(
      :name,
      :status,
      :website,
      :logo,
      :banner,
      :starts_at,
      :ends_at,
      :modality,
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
