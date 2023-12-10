module Event::Requested
  extend ActiveSupport::Concern

  included do
    has_one :request, dependent: :destroy

    before_create :build_request
  end
end
