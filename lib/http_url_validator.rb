class HttpUrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    uri = URI.parse(value)

    unless uri.is_a?(URI::HTTP) && uri.host.present?
      raise URI::InvalidURIError
    end
  rescue URI::InvalidURIError
    record.errors.add attribute, "is not a valid URL"
  end
end
