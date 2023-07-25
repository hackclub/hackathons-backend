shape_for subscription, json do
  json.status subscription.status

  json.location do
    json.extract! subscription, :city, :province, :country_code, :postal_code
  end

  json.subscriber do
    json.partial! "api/users/user", user: subscription.subscriber
  end
end
