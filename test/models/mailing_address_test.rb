require "test_helper"

class MailingAddressTest < ActiveSupport::TestCase
  test "creating a mailing address" do
    mailing_address = MailingAddress.new(
      line1: "15 Falls Rd",
      city: "Shelburne",
      province: "Vermont",
      postal_code: "05482",
      country_code: "US"
    )

    assert mailing_address.save
  end
end
