class User < ActiveRecord::Base
  has_many :authen_codes
end
