class ApplicationMailer < ActionMailer::Base
  default from: "hackathons@hackclub.com"
  layout "mailer"

  helper :mailer, :application

  after_action :set_unsubscribe_header

  private

  def set_unsubscribe_urls_for(user)
    @unsubscribe_url = Hackathon::Subscription.unsubscribe_all_url_for user
    @email_preferences_url = Hackathon::Subscription.manage_subscriptions_url_for user
  end

  def set_unsubscribe_header
    headers["List-Unsubscribe"] = "<#{@unsubscribe_url}>" if @unsubscribe_url
  end
end
