module Api::Pagination
  extend ActiveSupport::Concern

  included do
    include Pagy::Backend
    helper_method :pagy_metadata
    after_action { pagy_headers_merge(@pagy) if @pagy }
  end
end
