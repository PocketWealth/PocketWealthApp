class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.boolean :admin
      t.string :password_digest
      t.string :remember_digest

      t.timestamps
    end
    change_column :users, :admin, :boolean, default: false
  end
end
