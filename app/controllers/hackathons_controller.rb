class HackathonsController < ApplicationController
  skip_before_action :redirect_if_unauthenticated

  def index
  end
end
