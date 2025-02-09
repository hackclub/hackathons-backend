class AddContactsToLoops < ActiveRecord::Migration[7.2]
  def change
    return unless Rails.env.production?

    User.includes(:subscriptions).where(subscriptions: {status: :active}).find_each.with_index do |user, index|
      LoopsSynchronizationJob.set(wait: 3.seconds * index).perform_later(user)
    end
  end
end
