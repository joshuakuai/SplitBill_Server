class CreateAuthenCodes < ActiveRecord::Migration
  def change
    create_table :authen_codes do |t|
      t.string :code
      t.integer :type

      t.timestamps
    end
  end
end
