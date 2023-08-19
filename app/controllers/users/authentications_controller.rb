class Users::AuthenticationsController < ApplicationController
  skip_before_action :redirect_if_unauthenticated
  before_action :redirect_if_authenticated, only: [:new, :create]

  def new
  end

  def create
    @user = User.find_or_create_by(email_address: params[:email_address])
    @user&.authentications&.create! if @user.persisted?

    render :new, status: :unprocessable_entity
  end
end
