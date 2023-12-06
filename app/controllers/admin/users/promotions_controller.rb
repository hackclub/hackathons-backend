class Admin::Users::PromotionsController < Admin::BaseController
  include UserScoped

  def create
    @user.update! admin: true

    redirect_to admin_user_path(@user)
  end

  def destroy
    @user.update! admin: false

    redirect_to admin_user_path(@user)
  end
end
