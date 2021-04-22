# frozen_string_literal: true

class User::Password::Validation
  attr_reader :errors, :password, :password_confirmation

  def initialize(password, password_confirmation)
    @password = password
    @password_confirmation = password_confirmation
    @errors = {}
  end

  def errors?
    errors[:password] = ["can't be blank"] if password.invalid?
    errors[:password_confirmation] = ["can't be blank"] if password_confirmation.invalid?

    return true if errors.present?

    return false if password == password_confirmation

    errors[:password_confirmation] = ["doesn't match password"]

    true
  end
end
