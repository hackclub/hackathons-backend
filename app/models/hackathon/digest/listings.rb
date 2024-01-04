module Hackathon::Digest::Listings
  extend ActiveSupport::Concern

  included do
    has_many :listings, dependent: :destroy
    has_many :listed_hackathons, through: :listings, source: :hackathon
    has_many :listed_subscriptions, through: :listings, source: :subscription

    before_validation :build_candidate_listings, on: :create, if: -> { listings.empty? }
    validates_length_of :listings, minimum: 1, on: :create, message: "must not be empty"
  end

  private

  LISTING_CRITERIA = [Criterion::Location]
  MAX_LISTINGS = 8

  def build_candidate_listings
    applicable_listings.each do |result|
      listings.build hackathon: result[:hackathon], subscription: result[:subscription]
    end
  end

  def applicable_listings(listing_criteria: LISTING_CRITERIA, max_listings: MAX_LISTINGS)
    listing_criteria
      .flat_map { |criterion| criterion.new(recipient:).candidate_listings }
      .reject { |candidate|
        candidate[:hackathon].start_date > 1.month.from_now &&
          Listing.exists?(hackathon: candidate[:hackathon], recipient:, created_at: 3.months.ago..)
      }
      .sort_by { |candidate| candidate[:hackathon].starts_at }
      .first(max_listings)
  end
end
