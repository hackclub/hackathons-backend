class RemoveHackathonDigestEvents < ActiveRecord::Migration[7.2]
  def change
    Event.where(eventable_type: "Hackathon::Digest").in_batches.destroy_all
  end
end
