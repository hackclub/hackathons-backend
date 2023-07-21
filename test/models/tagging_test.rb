require "test_helper"

class TaggingTest < ActiveSupport::TestCase
  test "tagging a hackathon by name" do
    hackathon = hackathons(:assemble)

    assert_no_difference -> { hackathon.tags.count } do
      hackathon.tag_as "Ian Approved"
    end

    assert_difference -> { hackathon.tags.count }, 1 do
      hackathon.tag_as! "Matt A. Approved"
    end
  end

  test "tagging a hackathon" do
    hackathon = hackathons(:assemble)

    assert_no_difference -> { hackathon.tags.count } do
      hackathon.tag_with Tag.last
    end

    Tag.create! name: "Matt A. Approved"

    assert_difference -> { hackathon.tags.count }, 1 do
      hackathon.tag_with Tag.last
    end
  end

  test "tagging a hackathon with EVERYTHING" do
    hackathon = hackathons(:assemble)

    assert_no_difference -> { hackathon.tags.count } do
      hackathon.tag_with Tag.all
    end

    Tag.create! name: "Matt A. Approved"
    Tag.create! name: "Best Hackathon Ever"
    Tag.create! name: "Great Snacks"

    assert_difference -> { hackathon.tags.count }, 3 do
      hackathon.tag_with Tag.all
    end
  end

  test "untagging a hackathon by name" do
    hackathon = hackathons(:assemble)

    assert_no_difference -> { hackathon.tags.count } do
      hackathon.untag_as "Great Snacks"
    end

    hackathon.tag_as! "Great Snacks"

    assert_difference -> { hackathon.tags.count }, -1 do
      hackathon.untag_as "Great Snacks"
    end
  end

  test "untagging a hackathon" do
    hackathon = hackathons(:assemble)

    assert_no_difference -> { hackathon.tags.count } do
      hackathon.untag Tag.last
    end

    hackathon.tag_as! "Great Snacks"

    assert_difference -> { hackathon.tags.count }, -1 do
      hackathon.untag Tag.last
    end
  end
end
