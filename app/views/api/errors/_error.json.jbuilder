json.type @type
json.title @title
json.detail @detail
json.status @status_code

if Rails.env.development?
  json.development_debug do
    json.error_class @error.class.name
    json.full @error.inspect
    json.backtrace @error.backtrace
  end
end
