class User < ApplicationRecord
  include Eventable

  include Authenticatable
  include Identifiable
  include Named
  include Privileged # depends on Eventable
end
