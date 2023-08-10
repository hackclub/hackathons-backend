class ApplicationMailer < ActionMailer::Base
  default from: "hackathons@hackclub.com"
  layout "mailer"

  helper :mailer, :application

  before_action :set_default_unsubscribe_urls
  after_action :set_unsubscribe_header

  private

  def set_unsubscribe_urls_for(user)
    @unsubscribe_url = Hackathon::Subscription.unsubscribe_all_url_for user
    @email_preferences_url = Hackathon::Subscription.manage_subscriptions_url_for user
  end

  def set_default_unsubscribe_urls
    @unsubscribe_url = root_url
    @email_preferences_url = root_url
  end

  def set_unsubscribe_header
    headers["List-Unsubscribe"] = "<#{@unsubscribe_url}>" if @unsubscribe_url
  end
end
