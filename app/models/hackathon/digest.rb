class Hackathon::Digest < ApplicationRecord
  include Eventable

  include Deliverable # utilizes Eventable

  include Listings

  belongs_to :recipient, class_name: "User"

  private

  def delivery
    # TODO: Implement
    Class.new do
      def method_missing(_)
        # noop
      end
    end.new
  end
end
