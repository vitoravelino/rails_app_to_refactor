# frozen_string_literal: true

class User::Password
  attr_reader :value

  def initialize(value)
    @value = value.to_s.strip
  end

  def invalid?
    value.blank?
  end

  def ==(password)
    self.value == password.value
  end
end
