class User < ApplicationRecord
  has_many :articles

  # Config for simple_token_authentication
  # acts_as_token_authenticatable
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_save :ensure_authentication_token
end
