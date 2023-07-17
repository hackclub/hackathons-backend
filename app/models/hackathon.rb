class Hackathon < ApplicationRecord
  include Eventable
  include Taggable

  include Status
  include Named
  include Regional
  include Scheduled
end
