module ApplicationHelper
  # This method makes it easier to yield content with a default value.
  #
  # USAGE:
  # ```
  # <% yield_with_default_for :signature do %>
  #   Default signature here
  # <% end %>
  # ```
  #
  # The same functionality can be achieved with the following code:
  # ```
  # <% if content_for?(:signature) %>
  #   <%= yield :signature %>
  # <% else %>
  #   Default signature here
  # <% end %>
  # ```
  #
  # In helpers, `content_for` is used instead of `yield`.
  #
  # For more information regarding `yield` and `content_for`, see:
  # - https://guides.rubyonrails.org/layouts_and_rendering.html#understanding-yield
  # - https://apidock.com/rails/ActionView/Helpers/CaptureHelper/content_for
  # - https://apidock.com/rails/v5.2.3/ActionView/Helpers/CaptureHelper/content_for%3F
  def yield_with_default_for(key, &block)
    default_key = :"default_#{key}"
    before_key = :"before_#{key}"
    after_key = :"after_#{key}"

    content_for(default_key, &block)

    concat content_for(before_key) if content_for?(before_key)
    concat content_for?(key) ? content_for(key) : content_for(default_key)
    concat content_for(after_key) if content_for?(after_key)
  end
end
