require 'test_helper'

class User::Register::Step::NormalizeAttributesTest < ActiveSupport::TestCase
  test 'the attributes normalization' do
    # Arrange
    params = {
      user: {
        name: 'Rodrigo',
        email: 'rodrigo@serradura.com.br',
        password: ' 123456  ',
        password_confirmation: nil
      }
    }

    # Act
    result =
      User::Register::Step::NormalizeAttributes.call(params: params)

    # Assert
    assert result.success?

    assert_equal('Rodrigo', result[:name])
    assert_equal('rodrigo@serradura.com.br', result[:email])
    assert_equal('123456', result[:password])
    assert_equal('', result[:password_confirmation])
  end

  test 'should tranform the name and email into strings' do
    # Arrange
    params = ActionController::Parameters.new({
      user: {
        name: 1,
        email: nil,
        password: ' 123456  ',
        password_confirmation: nil
      }
    })

    # Act
    result =
      User::Register::Step::NormalizeAttributes.call(params: params)

    # Assert
    assert result.success?

    assert_equal('1', result[:name])
    assert_equal('', result[:email])
    assert_equal('123456', result[:password])
    assert_equal('', result[:password_confirmation])
  end
end
