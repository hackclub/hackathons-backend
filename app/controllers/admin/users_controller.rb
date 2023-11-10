class Admin::UsersController < Admin::BaseController
  before_action :set_user, except: :index

  def index
    @pagy, @users = pagy User.all.order(created_at: :desc)
  end

  def show
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user)
    else
      flash.now[:notice] = @user.errors.full_messages.to_sentence

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
