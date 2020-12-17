class RegisterUserUseCase < Micro::Case
  attribute :params

  def call!
    user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation)

    password = user_params[:password].to_s.strip
    password_confirmation = user_params[:password_confirmation].to_s.strip

    errors = {}
    errors[:password] = ["can't be blank"] if password.blank?
    errors[:password_confirmation] = ["can't be blank"] if password_confirmation.blank?

    if errors.present?
      return Failure :invalid_params, result: { errors: errors }
    else
      if password != password_confirmation
        error_data = { user: { password_confirmation: ["doesn't match password"] } }

        return Failure(:wrong_passwords, result: error_data)
      else
        password_digest = Digest::SHA256.hexdigest(password)

        user = User.new(
          name: user_params[:name],
          email: user_params[:email],
          token: SecureRandom.uuid,
          password_digest: password_digest
        )

        if user.save
          user_as_json = user.as_json(only: [:id, :name, :token])

          return Success result: { user: user_as_json }
        else
          return Failure :invalid_user, result: { user: user.errors.as_json }
        end
      end
    end

  rescue ActionController::ParameterMissing => exception
    Failure :parameter_missing, result: { message: exception.message }
  end
end
