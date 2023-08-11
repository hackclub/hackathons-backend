module HackathonScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_hackathon
  end

  private

  def set_hackathon
    @hackathon = Hackathon.find(params[:hackathon_id])
  end
end
