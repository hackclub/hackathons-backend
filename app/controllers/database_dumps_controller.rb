class DatabaseDumpsController < ApplicationController
  before_action :set_database_dump, except: %i[index create]

  def index
    @database_dumps = DatabaseDump.all
  end

  def create
    @database_dump = DatabaseDump.create! if Current.user&.admin?

    redirect_to database_dumps_path
  end

  def edit
  end

  def update
    @database_dump.update!(database_dump_params) if Current.user&.admin?

    redirect_to database_dumps_path
  end

  def destroy
    @database_dump.destroy! if Current.user&.admin?

    redirect_to database_dumps_path
  end

  private

  def set_database_dump
    @database_dump = DatabaseDump.find(params[:id])
  end

  def database_dump_params
    params.require(:database_dump).permit(:name)
  end
end
