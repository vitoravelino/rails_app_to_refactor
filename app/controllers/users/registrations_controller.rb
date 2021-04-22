# frozen_string_literal: true

class Users::RegistrationsController < ApplicationController
  def create
    User::Register.call(params: params) do |on|
      on.success { |result| render_json(201, user: result[:user]) }
      on.failure { |result| render_json(422, user: result[:errors]) }
    end
  end
end
