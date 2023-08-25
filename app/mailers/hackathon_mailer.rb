# frozen_string_literal: true

class HackathonMailer < ApplicationMailer
  def submission
    @name  = params[:name]
    @email = params[:email]
    mail to: @email, subject: 'A new Hackathon entry was submitted!'
  end
end
