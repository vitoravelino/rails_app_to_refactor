# frozen_string_literal: true

class User::Register::Step::NormalizeAttributes < Micro::Case
  attribute :params

  def call!
    user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation)

    Success result: {
      name: user_params[:name],
      email: user_params[:email],
      password: password(user_params[:password]),
      password_confirmation: password(user_params[:password_confirmation])
    }
  end

  private

    def password(value)
      value.to_s.strip
    end
end
