class User < ApplicationRecord
  include Eventable

  include Authenticatable
  include Identifiable
  include Named
  include Privileged
end
