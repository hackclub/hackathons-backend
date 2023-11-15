class Admin::Users::PromotionsController < Admin::BaseController
  include UserScoped

  def create
    @user.promote_to_admin
  end

  def destroy
    @user.demote_from_admin
  end
end
