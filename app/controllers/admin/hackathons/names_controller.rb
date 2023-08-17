class Admin::Hackathons::NamesController < Admin::BaseController
  include HackathonScoped

  def edit
  end

  def update
    if @hackathon.update(hackathon_params)
      redirect_to admin_hackathon_path(@hackathon)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def hackathon_params
    params.require(:hackathon).permit(:name)
  end
end
