# frozen_string_literal: true

class UsersService
  def self.register_user(params:)
    params = params.is_a?(ActionController::Parameters) ? params : ActionController::Parameters.new(params)

    user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation)

    password = User::Password.new(user_params[:password])
    password_confirmation = User::Password.new(user_params[:password_confirmation])

    password_validation = User::Password::Validation.new(password, password_confirmation)

    return failure(password_validation.errors) if password_validation.errors?

    password_digest = Digest::SHA256.hexdigest(password.value)

    user = User.new(
      name: user_params[:name],
      email: user_params[:email],
      token: SecureRandom.uuid,
      password_digest: password_digest
    )

    if user.save
      success(user.as_json(only: [:id, :name, :token]))
    else
      failure(user.errors.as_json)
    end
  end

  def self.failure(value)
    [false, value]
  end

  def self.success(value)
    [true, value]
  end
end
