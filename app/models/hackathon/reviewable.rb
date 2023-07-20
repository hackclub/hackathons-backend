module Hackathon::Reviewable
  extend ActiveSupport::Concern

  def approve
    transaction do
      update!(status: :approved)
      record(:approved)
    end
  end

  def deny
    transaction do
      update!(status: :denied)
      record(:denied)
    end
  end

  def hold
    transaction do
      update!(status: :pending)
      record(:held_for_review)
    end
  end
end
