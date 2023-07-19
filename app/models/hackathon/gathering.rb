module Hackathon::Gathering
  extend ActiveSupport::Concern

  included do
    enum modality: {in_person: 0, online: 1, hybrid: 2}

    validates :expected_attendees, presence: true, numericality: {greater_than: 0}
  end
end
