module StreamFlashes
  private

  def stream_flash_notice(notice = flash.now[:notice])
    flash.now[:notice] = notice
    render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash")
  end
end
