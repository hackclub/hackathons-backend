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
      json.total_count pagy.count
      json.total_pages pagy.pages
    end
  end

  # Adds standard attributes to JSON for a record.
  def shape_for(record, json)
    json.id record.hashid
    json.type record.class.try(:api_type) || record.class.name.underscore.parameterize

    yield if block_given?

    json.created_at record.created_at if record.respond_to?(:created_at)

    json.links do
      if (self_url = api_url_for(record))
        json.self self_url
      end
    end
  end

  # API URL for an record. By default, the api_version of the generated URL is
  # the same as the current request's version.
  def api_url_for(record, **)
    polymorphic_url([:api, record], api_version: @request_version, **)
  rescue NoMethodError
    nil
  end
end
