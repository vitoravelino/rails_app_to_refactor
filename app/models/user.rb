# frozen_string_literal: true

class User < ApplicationRecord
  has_many :todos

  validates :name, presence: true
  validates :email, presence: true, format: URI::MailTo::EMAIL_REGEXP, uniqueness: true
  validates :token, presence: true, length: { is: 36 }, uniqueness: true
  validates :password_digest, presence: true, length: { is: 64 }
end
