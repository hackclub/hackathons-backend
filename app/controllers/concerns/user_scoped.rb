module UserScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_user
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
