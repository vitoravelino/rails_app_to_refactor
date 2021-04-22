# frozen_string_literal: true

class User
  class Registration
    attr_reader :user

    def initialize(input)
      password = Password.new(input[:password])
      password_confirmation = Password.new(input[:password_confirmation])

      @name = input[:name]
      @email = input[:email]
      @password_validation = Password::Validation.new(password, password_confirmation)
    end

    def user
      @user ||= User.new(
        name: @name,
        email: @email,
        token: ::SecureRandom.uuid,
        password_digest: @password_validation.digest
      )
    end

    def errors
      @errors ||=
        if @password_validation.errors?
          @password_validation.errors
        else
          user.valid? ? {} : user.errors.as_json
        end
    end

    def perform
      errors.present? ? false : user.save
    end
  end
end
