class LoopsSynchronizationJob < ApplicationJob
  queue_as :low

  def perform(user)
    user.sync_with_loops
  rescue Faraday::BadRequestError
    Rails.logger.warn "Ignoring a 400 error from Loops when syncing User##{user.id}, most likely because of an invalid email address."
  end
end
