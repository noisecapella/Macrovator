class User < ActiveRecord::Base
  has_many :data

  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password
  validates :password, :presence => true, :length => { :minimum => 5 }
  
end
