require "test_helper"

class LocationTest < ActiveSupport::TestCase
  test "creating a location" do
    loc = Location.new("Seattle", "Washington", "US")

    assert_equal "Seattle", loc.city
    assert_equal "Washington", loc.province
    assert_equal "US", loc.country

    assert_equal "Seattle", loc.component(:city)
    assert_equal "Washington", loc.component(:province)
    assert_equal "US", loc.component(:country)

    assert_equal %w[Seattle Washington US], loc.components

    assert :city, loc.sig_component
  end

  test "creating a location without city" do
    loc = Location.new(nil, "Washington", "US")

    assert_nil loc.city
    assert_equal "Washington", loc.province
    assert_equal "US", loc.country

    assert_nil loc.component(:city)
    assert_equal "Washington", loc.component(:province)
    assert_equal "US", loc.component(:country)

    assert_equal [nil, "Washington", "US"], loc.components

    assert :province, loc.sig_component
  end

  test "creating a location without province" do
    loc = Location.new("Seattle", nil, "US")

    assert_equal "Seattle", loc.city
    assert_nil loc.province
    assert_equal "US", loc.country

    assert_equal "Seattle", loc.component(:city)
    assert_nil loc.component(:province)
    assert_equal "US", loc.component(:country)

    assert_equal ["Seattle", nil, "US"], loc.components

    assert :city, loc.sig_component
  end

  test "creating a location without city and province" do
    loc = Location.new(nil, nil, "US")

    assert_nil loc.city
    assert_nil loc.province
    assert_equal "US", loc.country

    assert_nil loc.component(:city)
    assert_nil loc.component(:province)
    assert_equal "US", loc.component(:country)

    assert_equal [nil, nil, "US"], loc.components

    assert :country, loc.sig_component
  end

  test "country covers city" do
    seattle = Location.new("Seattle", "Washington", "US")
    us = Location.new(nil, nil, "US")

    assert us.covers? seattle
    assert seattle.covered_by? us
    assert_not seattle == us
  end

  test "state covers city" do
    seattle = Location.new("Seattle", "Washington", "US")
    wa = Location.new(nil, "Washington", "US")

    assert wa.covers? seattle
    assert seattle.covered_by? wa
    assert_not seattle == wa
  end

  test "city equals city" do
    seattle1 = Location.new("Seattle", "Washington", "US")
    seattle2 = seattle1.dup

    assert seattle1 == seattle2
    assert seattle2 == seattle1

    assert seattle1.covers_or_equal? seattle2
    assert seattle2.covers_or_equal? seattle1

    assert_not seattle1.covers? seattle2
    assert_not seattle2.covers? seattle1

    assert_not seattle1.covered_by? seattle2
    assert_not seattle2.covered_by? seattle1
  end

  test "state equals state" do
    wa1 = Location.new(nil, "Washington", "US")
    wa2 = wa1.dup

    assert wa1 == wa2
    assert wa2 == wa1

    assert wa1.covers_or_equal? wa2
    assert wa2.covers_or_equal? wa1

    assert_not wa1.covers? wa2
    assert_not wa2.covers? wa1

    assert_not wa1.covered_by? wa2
    assert_not wa2.covered_by? wa1
  end

  test "country equals country" do
    us1 = Location.new(nil, nil, "US")
    us2 = us1.dup

    assert us1 == us2
    assert us2 == us1

    assert us1.covers_or_equal? us2
    assert us2.covers_or_equal? us1

    assert_not us1.covers? us2
    assert_not us2.covers? us1

    assert_not us1.covered_by? us2
    assert_not us2.covered_by? us1
  end
end
