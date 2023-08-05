module MailerHelper
  def recipient_name
    return unless @_message&.to&.one? # Abort if there are multiple recipients

    recipient = @recipient || @user || User.find_by_email_address(@_message&.to&.first)
    recipient&.first_name
  end
end
