class LoopsSynchronizationJob < ApplicationJob
  queue_as :low

  def perform(user)
    user.sync_with_loops
  end
end
