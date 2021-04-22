# frozen_string_literal: true

class Users::RegistrationsController < ApplicationController
  def create
    user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation)

    user_registering = User::Registering.new(user_params)

    if user_registering.perform
      user = user_registering.user

      render_json(201, user: user.as_json(only: [:id, :name, :token]))
    else
      render_json(422, user: user_registering.errors)
    end
  end
end
