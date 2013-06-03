class User < ActiveRecord::Base
  #attr_accessible :username, :first_name, :last_name, :email, :password, :password_confirmation
  #moved into controller

  attr_accessor :password
  before_save :encrypt_password

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  
  def self.authenticate(email, password)
  	user = User.get_id(mail)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password  	
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def self.fetch(data)
  	if data && thing.include?("@")
 		#user = User.where("email like ?",thing.downcase).first
 		user = find_by(email: email)
 	elsif thing
 		user = User.find_by(username: thing).first
 	end
 	user
  end
end
