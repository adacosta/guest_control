require "monocypher"

class RemoteCredential < Jennifer::Model::Base
  property password : String?

  with_timestamps
  mapping(
    id: {type: Int64, primary: true},
    username: String?,
    encrypted_password: String?,
    chamberlain_account_id: String?,
    chamberlain_security_token: String?,
    last_auth_request_at: Time?,
    time_zone: String?,
    user_id: Int64?,
    created_at: Time?,
    updated_at: Time?
  )

  belongs_to :user, User
  has_many :devices, Device

  before_save :check_username_changed

  def password=(value : String?)
    @new_password = value
    @encrypted_password = encrypt_password(value)
  end

  def password
    password_empty = encrypted_password.nil?

    if !password_empty
      _encrypted_password = encrypted_password.dup
      if _encrypted_password
        password_length = _encrypted_password && _encrypted_password.try &.size ? _encrypted_password.size : 0
        if password_length > 0
          _encrypted_password = Base64.decode(_encrypted_password.chomp) # bytes
          ciphertext = _encrypted_password.to_slice
          raise "ciphertext too short" if ciphertext.size < Crypto::OVERHEAD_SYMMETRIC
          result = Bytes.new(ciphertext.size - Crypto::OVERHEAD_SYMMETRIC)
          new_key = Crypto::SymmetricKey.new(key)
          unless Crypto.decrypt(key: new_key, input: ciphertext, output: result)
            raise "ciphertext is corrupt"
          end
          return String.new(result)
        end
      end
    end
    return nil
  end

  # must be 128 chars
  private def key
    ENV["REMOTE_CREDENTIAL_KEY"].chomp
  end

  private def encrypt_password(value : String?)
    if _password = value
      new_key = Crypto::SymmetricKey.new(key)
      ciphertext = Bytes.new(_password.size + Crypto::OVERHEAD_SYMMETRIC)
      Crypto.encrypt(key: new_key, input: _password.to_slice, output: ciphertext)
      self.encrypted_password = Base64.strict_encode(ciphertext).chomp
      encrypted_password
    end
  end

  private def check_username_changed
    if username_changed?
      self.chamberlain_account_id = nil
      save
    end
  end
end
