require 'test_helper'

class User::Register::Step::CreateRecordTest < ActiveSupport::TestCase
  test 'should create a user when receives a valid input' do
    # Arrange
    input = {
      name: 'Rodrigo',
      email: 'rodrigo.serradura@gmail.com',
      password: '123456'
    }

    # Act
    result = User::Register::Step::CreateRecord.call(input)

    # Assert
    assert result.success?

    user = result[:user]

    assert user.persisted?

    assert_instance_of(User, user)

    assert_equal('Rodrigo', user.name)
    assert_equal('rodrigo.serradura@gmail.com', user.email)
    assert_equal('8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', user.password_digest)

    assert user.token.present?
  end

  test 'should fail when receives an invalid input' do
    # Act
    result = User::Register::Step::CreateRecord.call({})

    # Arrange
    assert result.failure?

    assert_equal(
      {
        name: ["can't be blank"],\
        email: ["can't be blank", "is invalid"]
      },
      result[:errors]
    )
  end
end
