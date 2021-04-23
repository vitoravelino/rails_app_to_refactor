# frozen_string_literal: true

class User::Register::Step::NormalizeAttributes < Micro::Case
  AsParameters = ->(value) do
    value.is_a?(ActionController::Parameters) ? value : ActionController::Parameters.new(value)
  end

  attribute :params, default: AsParameters

  def call!
    user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation)

    Success result: {
      name: user_params[:name].to_s,
      email: user_params[:email].to_s,
      password: password(user_params[:password]),
      password_confirmation: password(user_params[:password_confirmation])
    }
  end

  private

    def password(value)
      value.to_s.strip
    end
end
