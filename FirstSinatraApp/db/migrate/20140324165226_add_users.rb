class AddUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password
      t.timestamps # created_at and updated_at
    end
  end
end
