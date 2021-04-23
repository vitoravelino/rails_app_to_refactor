# frozen_string_literal: true

class User::Register::Step::CreateRecord < Micro::Case
  attributes :name, :email, :password

  def call!
    password_digest = Digest::SHA256.hexdigest(password)

    user = User.new(
      name: name,
      email: email,
      token: SecureRandom.uuid,
      password_digest: password_digest
    )

    return Success result: { user: user } if user.save

    Failure result: { errors: user.errors.as_json }
  end
end
