# frozen_string_literal: true

module Authenticates
  class Login < ApplicationServices
    def initialize(email, password)
      @email = email
      @password = password
    end

    def call
      return nil unless user.present?

      return nil unless user.authenticate(@password)

      access_token
    end

    private

    def user
      @user ||= User.find_by_email(@email)
    end

    def access_token
      EncryptionString.encrypt(user.id)
    end
  end
end
