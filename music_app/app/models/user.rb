# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :password_digest, presence: true
  validates :session_token, presence: true, uniqueness: true
  after_initialize :ensure_session_token

  #Class method: as it is going to be generated for each session
  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end
  
  #Class method: returns user if email is found and password matches else return nil
  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)
    if user && user.is_password?(password)
      user
    else
      nil 
    end
  end

  #Instance method: assigns session_token to each user, stores it in DB using user.save, and returns user's session_token
  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end
  
  #Instance method: checks if user has a session_token, if not, assigns new session_token using #generate_session_token
  def ensure_session_token  
    self.session_token ||= User.generate_session_token
  end

  #Instance method: CREATES password_digest using BCrypt's Password's ::create method on password received
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end
  
  #Instance method: checks if the password matches password_digest of user
  def is_password?
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end


end
