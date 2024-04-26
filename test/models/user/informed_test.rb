require "test_helper"

class User::InformedTest < ActiveSupport::TestCase
  test "synchronization" do
    User.first.sync_with_loops
  end

  setup do
    stub_request(:get, Loops::Resource::BASE_URL + "contacts/find")
      .with(query: hash_including(:email)).to_return do |request|
      {body: [
        {
          id: Random.uuid,
          email: request.headers[:email],
          firstName: "Orpheus",
          lastName: nil,
          subscribed: true,
          userGroup: "Hack Clubber"
        }
      ]}
    end

    stub_request(:put, Loops::Resource::BASE_URL + "contacts/update")
      .with(body: hash_including(:email))
      .to_return({body: {id: Random.uuid}.to_json})

    stub_request(:post, Loops::Resource::BASE_URL + "contacts/create")
      .with(body: hash_including(:email))
      .to_return({body: {id: Random.uuid}.to_json})
  end
end
