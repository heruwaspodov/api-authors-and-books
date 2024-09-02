# frozen_string_literal: true

# Module for encrypting and decrypting strings using a secret key.
module EncryptionString
  def secret_key
    credential || secret
  end

  def credential
    Rails.application.credentials.secret_key_base
  end

  def secret
    Rails.application.secrets.secret_key_base
  end

  def msg_encryptor
    secret = secret_key[0..31]
    ActiveSupport::MessageEncryptor.new(secret)
  end

  def encrypt(string)
    Base64.urlsafe_encode64(msg_encryptor.encrypt_and_sign(string))
  end

  def decrypt(encrypted_data)
    encrypted_str = Base64.urlsafe_decode64(encrypted_data)
    msg_encryptor.decrypt_and_verify(encrypted_str)
  end

  module_function :encrypt, :decrypt, :msg_encryptor, :secret_key,
                  :credential, :secret
end
