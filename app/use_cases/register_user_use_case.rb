class RegisterUserUseCase < Micro::Case
  attribute :params

  def call!
    transaction {
      fetch_user_params
        .then(method(:validate_password_params))
        .then(method(:compare_passwords))
        .then(method(:create_user))
    }
    .then(method(:send_welcome_email_in_background))
    .then(method(:serialiaze_user_as_json))
  end

  private

    def fetch_user_params
      user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation)

      Success result: user_params.to_h.symbolize_keys

    rescue ActionController::ParameterMissing => exception
      Failure :parameter_missing, result: { message: exception.message }
    end

    def validate_password_params(**user_params)
      password = user_params[:password].to_s.strip
      password_confirmation = user_params[:password_confirmation].to_s.strip

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
