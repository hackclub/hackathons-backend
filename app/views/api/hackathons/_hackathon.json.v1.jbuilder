shape_for hackathon, json do
  json.extract!(hackathon,
    :name,
    :starts_at,
    :ends_at,
    :modality)

  json.website hackathon.website_or_archive_url

  json.logo_url hackathon_logo_url(hackathon)
  json.banner_url hackathon_banner_url(hackathon)

  json.location do
    json.city hackathon.city
    json.province hackathon.province
    json.country hackathon.country
    json.country_code hackathon.country_code

    json.longitude hackathon.longitude
    json.latitude hackathon.latitude
  end

  # This is temporary! See `Hackathon.apac?` for more info.
  json.apac hackathon.apac?
end
