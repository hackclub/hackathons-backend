module Hackathon::Digest::Listings
  extend ActiveSupport::Concern

  include ByLocation

  included do
    has_many :listings, dependent: :destroy
    has_many :listed_hackathons, through: :listings, source: :hackathon
    has_many :listed_subscriptions, through: :listings, source: :subscription

    before_create :build_list_of_relevant_hackathons
  end

  private

  MAX_LISTINGS = 8

  def build_list_of_relevant_hackathons(max_listings: MAX_LISTINGS)
    # TODO: handle case where there are no nearby hackathons (don't allow for creation of digest)
    nearby_upcoming_hackathons.first(max_listings).each do |result|
      listings.build hackathon: result[:hackathon], subscription: result[:subscription]
    end
  end
end
