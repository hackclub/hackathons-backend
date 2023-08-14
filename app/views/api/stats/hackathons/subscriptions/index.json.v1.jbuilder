json.cities do
  json.meta do
    json.count @subscriptions.distinct.count(:city)
  end
end

json.countries do
  json.meta do
    json.count @subscriptions.distinct.count(:country_code)
  end
end
