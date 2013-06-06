class User < ActiveRecord::Base
  #attr_accessible :username, :first_name, :last_name, :email, :password, :password_confirmation
  #moved into controller

  attr_accessor :password
  before_save :encrypt_password

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  
  has_many :rooms
  has_many :chats
  has_many :forum_posts
  has_many :blogs
  has_many :comments

  def self.authenticate(email, password)
  	user = User.fetch(email)
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
  	if data && data.include?("@")
 		#user = User.where("email like ?",thing.downcase).first
 		user = find_by(email: data)
 	elsif data
 		user = User.find_by(username: data)
 	end
 	user
  end

  def name
    [first_name.to_s, last_name.to_s].join(" ")
  end
end
