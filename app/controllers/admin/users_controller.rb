class Admin::UsersController < Admin::BaseController
  before_action :set_user, except: :index

  def index
    @email_address = params[:email_address]

    if (user = User.find_by_email_address @email_address)
      redirect_to admin_user_path(user)
    else
      flash.now[:notice] = "User not found."
  
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash") }

        format.html { render :edit, status: :unprocessable_entity }
      end
  end

  def show
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user)
    else
      flash.now[:notice] = @user.errors.full_messages.first

      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash") }

        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email_address)
  end
end
