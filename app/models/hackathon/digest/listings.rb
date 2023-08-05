module Hackathon::Digest::Listings
  extend ActiveSupport::Concern

  include ByLocation

  included do
    has_many :listings, dependent: :destroy
    has_many :listed_hackathons, through: :listings, source: :hackathon
    has_many :listed_subscriptions, through: :listings, source: :subscription

    before_validation :build_relevant_listings
    validates_length_of :listings, minimum: 1, on: :create, message: "must have at least one listing"
  end

  private

  MAX_LISTINGS = 8

  def build_relevant_listings(max_listings: MAX_LISTINGS)
    nearby_upcoming_hackathons.first(max_listings).each do |result|
      listings.build hackathon: result[:hackathon], subscription: result[:subscription]
    end
  end
end
