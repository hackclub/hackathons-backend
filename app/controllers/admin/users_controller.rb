class Admin::UsersController < Admin::BaseController
  before_action :set_user, except: :index

  def index
    @email_address = params[:email_address]
    return unless @email_address.present?

    if (user = User.find_by_email_address @email_address.downcase)
      redirect_to admin_user_path(user)
    else
      stream_flash_notice "User not found."
    end
  end

  def show
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user)
    else
      stream_flash_notice @user.errors.full_messages.first
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email_address, *User::SETTINGS)
  end
end
