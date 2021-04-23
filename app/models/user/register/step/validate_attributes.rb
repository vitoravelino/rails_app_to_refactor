# frozen_string_literal: true

class User::Register::Step::ValidateAttributes < Micro::Case
  attributes :name, :email, :password, :password_confirmation

  def call!
    errors = {}
    errors[:password] = ["can't be blank"] if password.blank?
    errors[:password_confirmation] = ["can't be blank"] if password_confirmation.blank?

    return invalid_attributes(errors) if errors.present?

    return invalid_attributes(password_confirmation: ["doesn't match password"]) if password != password_confirmation

    Success(:valid_attributes)
  end

  private

    def invalid_attributes(errors)
      Failure result: { errors: errors }
    end
end
