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
      .first(MAX_LISTINGS).each do |listing|
      listings << listing
    end
  end

  def candidates
    super || []
  end

  include ByLocation
  include MinimizingPreviouslyListedHackathons
end
