class Hackathon < ApplicationRecord
  include Eventable
  include Taggable

  include Status
  include Named
  include Regional
  include Scheduled
  include Brand
  include Gathering
end
