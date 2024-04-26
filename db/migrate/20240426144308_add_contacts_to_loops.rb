class AddContactsToLoops < ActiveRecord::Migration[7.2]
  def change
    return unless Rails.env.production?

    User.includes(:subscriptions).where(subscriptions: {status: :active}).find_each do |user|
      LoopsSynchronizationJob.perform_later(user)
    end
  end
end
