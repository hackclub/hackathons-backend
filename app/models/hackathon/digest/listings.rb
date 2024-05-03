module Hackathon::Digest::Listings
  extend ActiveSupport::Concern

  included do
    has_many :listings, dependent: :destroy
    has_many :listed_hackathons, through: :listings, source: :hackathon
    has_many :listed_subscriptions, through: :listings, source: :subscription

    before_validation :build_listings, on: :create, if: -> { listings.none? }
    validates_presence_of :listings, on: :create
  end

  private

  MAX_LISTINGS = 8

  def build_listings
    candidates
      .sort_by { |candidate| candidate.hackathon.starts_at }
      .first(max_listings).each do |listing|
      listings << listing
    end
  end

  def applicable_listings(max_listings: MAX_LISTINGS)
    candidates
      .sort_by { |candidate| candidate.hackathon.starts_at }
      .first(max_listings)
  end

  def candidates
    []
  end

  include ByLocation
  include ExcludingPreviouslyListedHackathons
end
