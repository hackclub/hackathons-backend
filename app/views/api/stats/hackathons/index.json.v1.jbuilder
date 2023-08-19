json.status do
  json.pending do
    json.meta do
      json.count @hackathons.pending.count
    end
  end
end
