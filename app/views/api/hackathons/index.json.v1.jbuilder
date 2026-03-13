paginated json do
  json.array! @page.records, partial: "hackathon", as: :hackathon, cached: true
end
