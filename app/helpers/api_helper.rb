module ApiHelper
  def paginated(json)
    json.data do
      yield
    end

    unless @page.last?
      json.links do
        json.next url_for(page: @page.next_param)
      end
    end

    json.meta do
      json.total_count @page.recordset.records_count
      json.total_pages @page.recordset.page_count
    end
  end

  # Adds standard attributes to JSON for a record.
  def shape_for(record, json)
    json.id record.hashid
    json.type record.class.try(:api_type) || record.class.name.underscore.parameterize

    yield if block_given?

    json.created_at record.created_at if record.respond_to?(:created_at)
  end

  # API URL for an record. By default, the api_version of the generated URL is
  # the same as the current request's version.
  def api_url_for(record, **)
    polymorphic_url([:api, record], api_version: @request_version, **)
  rescue NoMethodError
    nil
  end

  # Permanent URL for an attached file or variant
  def file_url_for(attachable, variant = nil)
    return nil if attachable.is_a?(ActiveStorage::Attached) && !attachable.attached?

    attachable = attachable.variant(variant) if variant && attachable.variable?
    polymorphic_url(attachable)
  end
end
