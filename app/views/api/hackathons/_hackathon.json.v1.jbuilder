shape_for hackathon, json do
  json.extract!(hackathon,
    :name,
    :starts_at,
    :ends_at,
    :website,
    :modality)

  json.logo_url file_url_for hackathon.logo, :small
  json.banner_url file_url_for hackathon.banner, :large

  json.location do
    json.city hackathon.city
    json.state hackathon.province
    json.country hackathon.country_code
    json.longitude hackathon.longitude
    json.latitude hackathon.latitude
  end
end
