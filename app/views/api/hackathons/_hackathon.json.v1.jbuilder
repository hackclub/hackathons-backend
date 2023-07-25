obj json, hackathon do
  json.extract!(hackathon,
    :name,
    :starts_at,
    :ends_at,
    :website,
    :modality)

  json.logo file_url_for hackathon.logo, :small
  json.banner file_url_for hackathon.banner, :large

  json.location do
    json.city hackathon.city
    json.state hackathon.province
    json.country hackathon.country_code
    json.longitude hackathon.longitude
    json.latitude hackathon.latitude
  end

  # TBD: whether we should expose tags in the API
  # json.tags do
  #   json.array! hackathon.tags.map(&:name)
  # end
end
