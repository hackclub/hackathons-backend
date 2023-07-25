json.type @type
json.title @title
json.detail @detail
json.status @status_code

if Rails.env.development?
  json.development_debug do
    json.extract! @error, :inspect
  end
end
