class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password
      t.string :session_token
      t.integer :balance
      t.timestamps
    end
  end
end
