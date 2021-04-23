# frozen_string_literal: true

class User::Register::Step::SendWelcomeEmail < Micro::Case
  attribute :user
  attribute :mailer

  def call!
    mailer.with(user: user).welcome.deliver_later

    Success(:email_sent)
  end
end

