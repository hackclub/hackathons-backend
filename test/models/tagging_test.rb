require "test_helper"

class TaggingTest < ActiveSupport::TestCase
  setup do
    @hackathon = hackathons(:zephyr)
  end

  test "checking for tags" do
    assert @hackathon.tags.none?

    @hackathon.taggings.create! tag: Tag.new(name: "Tag")

    assert @hackathon.tagged_with? "Tag"
    assert @hackathon.tagged_with? Tag.last

    assert_not @hackathon.tagged_with? "Nonexistent"
    assert_not @hackathon.tagged_with? nil
  end

  test "scoping by tags" do
    assert Hackathon.tagged_with("Great Snacks").none?
    assert Hackathon.tagged_with(Tag.last).none?

    @hackathon.taggings.create! tag: Tag.new(name: "Great Snacks")

    assert_includes Hackathon.tagged_with("Great Snacks"), @hackathon

    Tag.create! name: "Matt A. Approved"
    assert_not_includes Hackathon.tagged_with("Matt A. Approved"), @hackathon
    assert_not_includes Hackathon.tagged_with(Tag.last), @hackathon
  end

  test "tagging a hackathon by name" do
    assert_no_difference -> { @hackathon.tags.count } do
      @hackathon.tag_with "Ian Approved"
    end

    assert_difference -> { @hackathon.tags.count }, 1 do
      @hackathon.tag_with! "Matt A. Approved"
    end
  end

  test "tagging a hackathon" do
    assert_no_difference -> { @hackathon.tags.count } do
      @hackathon.tag_with Tag.last
    end

    Tag.create! name: "Matt A. Approved"

    assert_difference -> { @hackathon.tags.count }, 1 do
      @hackathon.tag_with Tag.last
    end
  end

  test "tagging a hackathon with EVERYTHING" do
    assert_no_difference -> { @hackathon.tags.count } do
      @hackathon.tag_with Tag.all
    end

    Tag.create! name: "Matt A. Approved"
    Tag.create! name: "Best Hackathon Ever"
    Tag.create! name: "Great Snacks"

    assert_difference -> { @hackathon.tags.count }, 3 do
      @hackathon.tag_with Tag.all
    end
  end

  test "untagging a hackathon by name" do
    assert_no_difference -> { @hackathon.tags.count } do
      @hackathon.untag "Great Snacks"
    end

    @hackathon.tag_with! "Great Snacks"

    assert_difference -> { @hackathon.tags.count }, -1 do
      @hackathon.untag "Great Snacks"
    end
  end

  test "untagging a hackathon" do
    assert_no_difference -> { @hackathon.tags.count } do
      @hackathon.untag Tag.last
    end

    @hackathon.tag_with! "Great Snacks"

    assert_difference -> { @hackathon.tags.count }, -1 do
      @hackathon.untag Tag.last
    end
  end
end
