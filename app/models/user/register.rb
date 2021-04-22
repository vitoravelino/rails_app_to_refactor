# frozen_string_literal: true

class User::Register < Micro::Case
  attribute :params

  def call!
    user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation)

    password = user_params[:password].to_s.strip
    password_confirmation = user_params[:password_confirmation].to_s.strip

    errors = {}
    errors[:password] = ["can't be blank"] if password.blank?
    errors[:password_confirmation] = ["can't be blank"] if password_confirmation.blank?

    return invalid_attributes(errors) if errors.present?

    return invalid_attributes(password_confirmation: ["doesn't match password"]) if password != password_confirmation

    password_digest = Digest::SHA256.hexdigest(password)

    user = User.new(
      name: user_params[:name],
      email: user_params[:email],
      token: SecureRandom.uuid,
      password_digest: password_digest
    )

    return invalid_attributes(user.errors.as_json) unless user.save

    Success result: { user: user.as_json(only: [:id, :name, :token]) }
  end

  private

    def invalid_attributes(errors)
      Failure result: { errors: errors }
    end
end
