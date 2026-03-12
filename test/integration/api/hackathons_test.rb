require "test_helper"

class Api::HackathonsTest < ActionDispatch::IntegrationTest
  test "getting paginated hackathons" do
    get "/api/v1/hackathons", headers: {"Accept" => "application/json"}
    assert_response :success

    body = JSON.parse(response.body)

    assert body.key?("data")
    assert body["data"].is_a?(Array)
    assert body.key?("meta")
    assert body["meta"].key?("total_count")
    assert body["meta"].key?("total_pages")

    entry = body["data"].first
    assert entry

    assert_includes entry.keys, "id"
    assert_includes entry.keys, "type"
    assert_includes entry.keys, "name"
    assert_includes entry.keys, "starts_at"
    assert_includes entry.keys, "ends_at"
    assert_includes entry.keys, "modality"
    assert_includes entry.keys, "website"
    assert_includes entry.keys, "logo_url"
    assert_includes entry.keys, "banner_url"
    assert_includes entry.keys, "location"
    assert_includes entry.keys, "apac"
    assert_includes entry.keys, "created_at"

    assert entry["location"].is_a?(Hash)
    assert_includes entry["location"].keys, "city"
    assert_includes entry["location"].keys, "province"
    assert_includes entry["location"].keys, "country"
    assert_includes entry["location"].keys, "country_code"
    assert_includes entry["location"].keys, "longitude"
    assert_includes entry["location"].keys, "latitude"
  end
end
