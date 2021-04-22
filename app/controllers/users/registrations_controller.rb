# frozen_string_literal: true

class Users::RegistrationsController < ApplicationController
  def create
    succeed, user = UsersService.register_user(params: params)

    status = succeed ? 201 : 422

    render_json(status, user: user)
  end
end
