class Hackathon < ApplicationRecord
  include Eventable

  include Status
  include Named
  include Regional
  include Scheduled
end
