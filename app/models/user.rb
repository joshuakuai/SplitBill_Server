class User < ActiveRecord::Base
  has_many :authen_codes
  validates :email, :session_token, presence:true
  validates :email, uniqueness: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
end
