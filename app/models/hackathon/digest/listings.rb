module Hackathon::Digest::Listings
  extend ActiveSupport::Concern

  include ByLocation

  included do
    has_many :listings, dependent: :destroy
    has_many :listed_hackathons, through: :listings

    before_create :build_list_of_relevant_hackathons
  end

  private

  MAX_LISTINGS = 5

  def build_list_of_relevant_hackathons
    nearby_upcoming_hackathons.first(MAX_LISTINGS).each do |hackathon|
      listings.create! hackathon: hackathon
    end
  end
end
