require "test_helper"

class Api::HackathonsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_hackathons_url api_version: 1

    assert_response :success

    hackathons = @response.parsed_body

    assert_equal Hackathon.count, hackathons["meta"]["total_count"]
  end

  test "should get hackathon" do
    get api_hackathon_url hackathons(:assemble), api_version: 1
    assert_response :success

    hackathon = @response.parsed_body
    assert_equal hackathons(:assemble).hashid, hackathon["id"]
  end

  test "non-existent hackathon" do
    get api_hackathons_url id: "iDontExist", api_version: 1
    assert_response :not_found

    error = @response.parsed_body
    assert_equal "not_found_error", error["type"]
  end
end
