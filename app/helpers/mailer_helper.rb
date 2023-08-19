module MailerHelper
  def recipient_name
    recipient_emails =
      if @_message&.to&.is_a?(String)
        # Comma-separated list of email addresses
        @_message.to.split(",")
      else
        # Array of email addresses
        @_message&.to || []
      end

    return if recipient_emails.many? # Abort if multiple recipients

    recipient = @recipient || @user || User.find_by_email_address(recipient_emails.first)
    recipient&.first_name
  end
end
