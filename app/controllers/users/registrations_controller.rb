# frozen_string_literal: true

class Users::RegistrationsController < ApplicationController
  def create
    user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation)

    registration = User::Registration.new(user_params)

    if registration.perform
      user = registration.user

      render_json(201, user: user.as_json(only: [:id, :name, :token]))
    else
      render_json(422, user: registration.errors)
    end
  end
end
