class ChangeTokenTypeName < ActiveRecord::Migration
  def change
    change_table :authen_codes do |t|
      t.rename :type, :authen_type
    end
  end
end
