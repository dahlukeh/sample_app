# == Schema Information
# Schema version: 20110214044508
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation

  has_many :microposts, :dependent => :destroy

  email_cool = /\A[\w]+(\.[\w]+)*@[a-z]+(\.([a-z]+))+\z/i

  validates :name,      :presence => true,
                        :length => { :maximum => 50}
  validates :email,     :presence => true,
                        :format => { :with => email_cool },
                        :uniqueness => { :case_sensitive => false }
  validates :password,  :presence => true,
                        :confirmation => true,
                        :length => { :within => 6..30 }

  before_save :encrypt_password


  def correct_password?(attempt_pw)
    encrypted_password == encrypt(attempt_pw)
  end

  def self.authenticate(email, attempt_pw)
    user = find_by_email(email)
    if user.nil?
      nil
    elsif user.correct_password?(attempt_pw)
      user
    else
      nil
    end
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    if user.nil?
      nil
    elsif user.salt == cookie_salt
      user
    else
      nil
    end
  end

  def feed
    Micropost.where("user_id = ?", id)
  end

  private
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

end

