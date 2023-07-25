module ApiHelper
  # Shape for a paginated response
  def paginated(json, pagy)
    json.data do
      yield
    end

    json.links do
      scaffold_url = pagy_metadata(pagy, absolute: true)[:scaffold_url]
      url_for_page = ->(page) do
        next nil if page.nil?
        scaffold_url.gsub("__pagy_page__", page.to_s)
      end

      json.first url_for_page.call(1)

      %i[prev next last].each do |link|
        json.set! link, url_for_page.call(pagy.public_send(link))
      end

      json.self url_for_page.call(pagy.page)
    end

    json.meta do
      json.extract! pagy, :count, :pages
    end
  end

  # Shape for an object
  def obj(json, object)
    json.id object.hashid
    json.type object.class.try(:api_type) || object.class.name.underscore

    yield if block_given?

    json.created_at object.created_at if object.respond_to?(:created_at)
    json.links do
      json.self api_url_for(object)
    end
  end

  # API URL for an object. By default, the api_version of the generated URL is
  # the same as the current request's version.
  def api_url_for(object, **options)
    polymorphic_url([:api, object], api_version: @request_version, **options)
  end

  # Permanent URL for an attached file or variant
  def file_url_for(attachable, variant = nil)
    return nil if attachable.is_a?(ActiveStorage::Attached) && !attachable.attached?

    attachable = attachable.variant(variant) if variant
    polymorphic_url(attachable)
  end
end
