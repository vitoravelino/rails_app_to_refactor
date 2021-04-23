# frozen_string_literal: true

class User::Register::Step::SendWelcomeEmail < Micro::Case
  attributes :user

  def call!
    ::UserMailer.with(user: user).welcome.deliver_later

    Success(:email_sent)
  end
end

