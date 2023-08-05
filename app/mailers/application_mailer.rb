class ApplicationMailer < ActionMailer::Base
  default from: "hackathons@hackclub.com"
  layout "mailer"

  helper :mailer, :application

  after_action :set_unsubscribe_header

  private

  def set_unsubscribe_header
    url = @unsubscribe_url || root_url
    headers["List-Unsubscribe"] = "<#{url}>" if url
  end
end
