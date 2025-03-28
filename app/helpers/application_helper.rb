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
  def yield_with_default_for(key, &)
    default_key = :"default_#{key}"
    before_key = :"before_#{key}"
    after_key = :"after_#{key}"

    content_for(default_key, &)

    concat content_for(before_key) if content_for?(before_key)
    concat content_for?(key) ? content_for(key) : content_for(default_key)
    concat content_for(after_key) if content_for?(after_key)
  end

  def avatar(user, size: "32px", **options)
    return if user.nil?

    default_options = {
      alt: "#{user.name} profile picture",
      class: "align-middle size-[#{size}] rounded-full"
    }

    image_tag user.gravatar_url, default_options.deep_merge(options)
  end

  def ui_avatars(name, html: {}, **options)
    url = URI.parse("https://ui-avatars.com/api/")
    url.query = URI.encode_www_form({name:}.deep_merge(options))
    image_tag url.to_s, **html
  end

  def classes_for_hackathon_status(status)
    case status
    when "approved"
      "text-(--green)"
    when "rejected"
      "text-(--red)"
    when "pending"
      "text-(--slate)"
    end <<
      " border-current bg-[color-mix(in srgb, currentcolor) 3%, transparent);]"
  end

  def page(size)
    size = :normal unless %i[full wide copy narrow].include?(size)
    return if size == :normal

    content_for(:container_class) { size.to_s }
  end
end
