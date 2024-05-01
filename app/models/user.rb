class User < ApplicationRecord
  include Broadcasting
  include Eventable

  include Authenticatable
  include Identifiable
  include Informed
  include Named
  include Privileged # depends on Eventable
  include Settings
  include Subscriber
end
