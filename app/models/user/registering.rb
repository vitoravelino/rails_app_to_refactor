# frozen_string_literal: true

class User::Registering
  attr_reader :user

  def initialize(name:, email:, password:)
    @user = build_user(name, email, password)
  end

  def persist
    @user.save
  end

  def errors
    @user.errors
  end

  private

    def build_user(name, email, password)
      User.new(
        name: name,
        email: email,
        token: SecureRandom.uuid,
        password_digest: password.digest
      )
    end
end
