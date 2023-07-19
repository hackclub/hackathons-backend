module Hackathon::Applicant
  extend ActiveSupport::Concern

  included do
    belongs_to :applicant, class_name: "User"
  end
end
