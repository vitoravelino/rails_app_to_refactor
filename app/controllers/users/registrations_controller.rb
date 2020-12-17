# frozen_string_literal: true

class Users::RegistrationsController < ApplicationController
  def create
    RegisterUser.call(user_params.to_h) do |on|
      on.success { |result| render_user_json(201, result[:user]) }
      on.failure(:invalid_user) { |data| render_422(data[:user]) }
      on.failure(:invalid_params) { |data| render_422(data[:errors]) }
      on.failure(:wrong_passwords) { |data| render_422(data[:user]) }
    end
  rescue ActionController::ParameterMissing => exception
    render_json(400, error: exception.message)
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def render_user_json(status, json)
      render_json(status, user: json)
    end

    def render_422(json)
      render_json(422, user: json)
    end
end
