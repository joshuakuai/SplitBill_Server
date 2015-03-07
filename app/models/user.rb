class User < ActiveRecord::Base
  has_many :authen_codes
  validates :balance, numericality: { greater_than: 0 }
end
