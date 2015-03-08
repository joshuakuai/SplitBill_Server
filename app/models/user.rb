class User < ActiveRecord::Base
  has_many :authen_codes
  validates :email, :session_token, presence:true
  validates :email, uniqueness: true
  validates :email, format: { with: /\A([-a-z0-9!\#$%&'*+\/=?^_`{|}~]+\.)*[-a-z0-9!\#$%&'*+\/=?^_`{|}~]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create }
  validates :balance, numericality: { greater_than_or_equal_to: 0 }
end
