# frozen_string_literal: true

class Users::RegistrationsController < ApplicationController
  def create
    RegisterUserUseCase.call(params: params) do |on|
      on.success { |result| render_user_json(201, result[:user]) }
      on.failure(:invalid_user) { |data| render_422(data[:user]) }
      on.failure(:invalid_params) { |data| render_422(data[:errors]) }
      on.failure(:wrong_passwords) { |data| render_422(data[:user]) }
      on.failure(:parameter_missing) { |data| render_json(400, error: data[:message]) }
    end
  end

  private

    def render_user_json(status, json)
      render_json(status, user: json)
    end

    def render_422(json)
      render_json(422, user: json)
    end
end
