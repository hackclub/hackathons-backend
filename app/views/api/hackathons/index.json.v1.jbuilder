paginated json, @hackathons do
  json.array! @hackathons, partial: "hackathon", as: :hackathon
end
