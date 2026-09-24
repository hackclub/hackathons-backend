class MailDeliveryJob < ActionMailer::MailDeliveryJob
  retry_on Net::SMTPServerBusy, wait: :polynomially_longer
end
