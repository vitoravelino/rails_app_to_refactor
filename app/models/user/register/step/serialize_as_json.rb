# frozen_string_literal: true

class User::Register::Step::SerializeAsJson < Micro::Case
  attribute :user

  def call!
    Success result: { user: user.as_json(only: [:id, :name, :token]) }
  end
end
