# frozen_string_literal: true

class UsersService
  def self.register_user(params:)
    params = params.is_a?(ActionController::Parameters) ? params : ActionController::Parameters.new(params)

    user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation)

    password = User::Password.new(user_params[:password])
    password_confirmation = User::Password.new(user_params[:password_confirmation])

    errors = {}
    errors[:password] = ["can't be blank"] if password.invalid?
    errors[:password_confirmation] = ["can't be blank"] if password_confirmation.invalid?

    if errors.present?
      [false, errors]
    else
      if !(password == password_confirmation)
        [false, { password_confirmation: ["doesn't match password"] }]
      else
        password_digest = Digest::SHA256.hexdigest(password.value)

        user = User.new(
          name: user_params[:name],
          email: user_params[:email],
          token: SecureRandom.uuid,
          password_digest: password_digest
        )

        if user.save
          [true, user.as_json(only: [:id, :name, :token])]
        else
          [false, user.errors.as_json]
        end
      end
    end
  end
end
