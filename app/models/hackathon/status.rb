module Hackathon::Status
  extend ActiveSupport::Concern

  included do
    enum status: {pending: 0, approved: 1, rejected: 2}
  end
end
