module Broadcasting
  extend ActiveSupport::Concern

  included do
    broadcasts_refreshes
  end
end
