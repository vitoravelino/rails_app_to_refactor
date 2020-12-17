class RegisterUser < Micro::Case
  attribute :name
  attribute :email
  attribute :password, default: -> value { value.to_s.strip }
  attribute :password_confirmation, default: -> value { value.to_s.strip }

  def call!
    transaction {
      validate_password_params
        .then(method(:compare_passwords))
        .then(method(:create_user))
    }
    .then(method(:send_welcome_email_in_background))
    .then(method(:serialiaze_user_as_json))
  end

  private

    def validate_password_params
      errors = {}
      errors[:password] = ["can't be blank"] if password.blank?
      errors[:password_confirmation] = ["can't be blank"] if password_confirmation.blank?

      if errors.blank?
        Success(:valid_params, result: {password: password, password_confirmation: password_confirmation})
      else
        Failure :invalid_params, result: { errors: errors }
      end
    end

    def compare_passwords(password:, password_confirmation:, **)
      return Success() if password == password_confirmation

      error_data = { user: { password_confirmation: ["doesn't match password"] } }

      Failure(:wrong_passwords, result: error_data)
    end

    def create_user(**user_data)
      password, name, email = user_data.values_at(:password, :name, :email)

      password_digest = Digest::SHA256.hexdigest(password)

      user = User.new(
        name: name,
        email: email,
        token: SecureRandom.uuid,
        password_digest: password_digest
      )

      if user.save
        Success result: { user: user }
      else
        Failure :invalid_user, result: { user: user.errors.as_json }
      end
    end

    def send_welcome_email_in_background(user:, **)
      UserMailer.with(user: user).welcome.deliver_later

      Success(:welcome_email_was_sent)
    end

    def serialiaze_user_as_json(user:, **)
      user_as_json = user.as_json(only: [:id, :name, :token])

      Success result: { user: user_as_json }
    end
end
