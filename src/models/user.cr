require "crypto/bcrypt/password"

class User < Jennifer::Model::Base
  include Crypto

  with_timestamps
  mapping(
    id: {type: Int64, primary: true},
    email: String?,
    hashed_password: String?,
    created_at: Time?,
    updated_at: Time?
  )

  validates_with_method :email_present
  validates_uniqueness :email
  validates_length :password, minimum: 8, maximum: 64

  # validate :email, "is required", ->(user : User) do
  #   (email = user.email) ? !email.empty? : false
  # end

  # validate :email, "already in use", ->(user : User) do
  #   existing = User.find_by email: user.email
  #   !existing || existing.id == user.id
  # end

  # validate :password, "is too short", ->(user : User) do
  #   user.password_changed? ? user.valid_password_size? : true
  # end

  def password=(password)
    @new_password = password
    @hashed_password = Bcrypt::Password.create(password, cost: 10).to_s
  end

  def password
    (hash = hashed_password) ? Bcrypt::Password.new(hash).to_s : nil
  end

  def password_changed?
    new_password ? true : false
  end

  # def valid_password_size?
  #   (pass = new_password) ? pass.size >= 8 : false
  # end

  def authenticate(password : String)
    if _hashed_password = hashed_password
      !!(Bcrypt::Password.new(_hashed_password).try &.verify(password))
    end
  end

  private getter new_password : String?

  private def email_present : Bool
    # if @email && @email.not_nil!.empty?
    #   return true
    # end
    # errors.add(:email, "is blank")
    # return false
    (_email = email) ? !_email.empty? : false
  end
end
