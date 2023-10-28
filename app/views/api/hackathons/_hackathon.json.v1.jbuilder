shape_for hackathon, json do
  json.extract!(hackathon,
    :name,
    :starts_at,
    :ends_at,
    :modality)

  json.website begin
    if hackathon.tagged_with?("Website Down") && hackathon.website_archived?
      hackathon.website_archive_url
    else
      hackathon.website
    end
  end

  json.logo_url file_url_for hackathon.logo, :small
  json.banner_url file_url_for hackathon.banner, :large

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
