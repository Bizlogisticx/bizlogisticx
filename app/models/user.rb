class User < ActiveRecord::Base
  attr_accessible :admin, :email, :first, :last, :password, :password_confirmation
  has_secure_password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_confirmation_of :password
end
