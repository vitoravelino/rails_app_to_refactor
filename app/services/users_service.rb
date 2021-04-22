# frozen_string_literal: true

class UsersService
  def self.register_user(params:)
    params = params.is_a?(ActionController::Parameters) ? params : ActionController::Parameters.new(params)

    user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation)

    password = User::Password.new(user_params[:password])
    password_confirmation = User::Password.new(user_params[:password_confirmation])

    password_validation = User::Password::Validation.new(password, password_confirmation)

    return failure(password_validation.errors) if password_validation.errors?

    user_registering = User::Registering.new(
      name: user_params[:name],
      email: user_params[:email],
      password: password
    )

    if user_registering.persist
      user_as_json = user_registering.user.as_json(only: [:id, :name, :token])

      success(user_as_json)
    else
      failure(user_registering.errors.as_json)
    end
  end

  def self.failure(value)
    [false, value]
  end

  def self.success(value)
    [true, value]
  end
end
