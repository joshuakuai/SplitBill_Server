class AddUserRefsToAuthenToken < ActiveRecord::Migration
  def change
    add_reference :authen_codes, :user, index: true
  end
end
