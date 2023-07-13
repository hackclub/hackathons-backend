class User < ApplicationRecord
  include Eventable

  include Identifiable
  include Named
  include Privileged
end
