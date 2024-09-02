# frozen_string_literal: true

module Authenticates
  class Validate < ApplicationServices
    def initialize(authorization)
      @access_token = process_bearer_token(authorization)
    end

    def call
      return false unless @access_token.present?

      return false unless user_check.present?

      user_check
    end

    private

    def user_check
      @user_check ||= User.find_by_id(decrypt_access_token)
    end

    def decrypt_access_token
      @decrypt_access_token ||= EncryptionString.decrypt(@access_token)
    end

    def process_bearer_token(authorization)
      pattern = /^Bearer/
      header = authorization
      header.gsub(pattern, '').strip if header&.match(pattern)
    end
  end
end
