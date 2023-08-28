# frozen_string_literal: true

class HackathonMailer < ApplicationMailer
  def submission
    @hackathon = params[:hackathon]
    email_addresses = User.admins.collect(&:email_address)
    mail to: email_addresses, subject: 'A new Hackathon entry was submitted!'
  end
end
