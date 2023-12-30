class Users::AuthenticationsController < ApplicationController
  allow_unauthenticated_access
  before_action :redirect_if_authenticated

  def new
  end

  def create
    @user = User.find_or_create_by(email_address: params[:email_address])
    @user&.authentications&.create! if @user.persisted?

    render :new, status: :unprocessable_entity
  end
end
