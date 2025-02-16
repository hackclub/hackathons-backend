module ReadOnlyMode
  extend ActiveSupport::Concern

  included do
    rescue_from ReadOnlyModeError do
      stream_flash_notice \
        "The app is in read only mode for maintenance. Try again in a few minutes."
    end
  end
end
