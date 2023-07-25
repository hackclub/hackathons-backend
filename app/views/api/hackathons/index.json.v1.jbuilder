paginated json, @pagy do
  json.array! @hackathons, partial: "hackathon", as: :hackathon
end
