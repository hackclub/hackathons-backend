require "test_helper"

class Api::SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  test "should create" do
    assert_difference("Hackathon::Subscription.count", 1) do
      post api_subscriptions_url api_version: 1,
        params: {
          email: "gary@hackclub.com",
          location: "Seattle, WA"
        },
        as: :json
    end

    subscription = @response.parsed_body

    assert_equal subscription["id"], Hackathon::Subscription.last.hashid
  end

  test "should not create with invalid email" do
    assert_no_difference("Hackathon::Subscription.count") do
      post api_subscriptions_url api_version: 1,
        params: {
          email: "gary",
          location: "Seattle, WA"
        },
        as: :json
    end

    assert_response :bad_request

    error = @response.parsed_body
    assert_equal error["type"], "bad_request_error"
  end

  test "should not create with missing email" do
    assert_no_difference("Hackathon::Subscription.count") do
      post api_subscriptions_url api_version: 1,
        params: {
          location: "Seattle, WA"
        },
        as: :json
    end
  end

  test "should not create with missing location" do
    assert_no_difference("Hackathon::Subscription.count") do
      post api_subscriptions_url api_version: 1,
        params: {
          email: "gary@hackclub.com"
        },
        as: :json
    end
  end
end
