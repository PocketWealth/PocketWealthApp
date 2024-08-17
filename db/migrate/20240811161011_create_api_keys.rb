class CreateApiKeys < ActiveRecord::Migration[7.2]
  def change
    create_table :api_keys do |t|
      t.string :provider
      t.string :access_token
      t.string :refresh_token
      t.string :url

      t.timestamps
    end
    add_index :api_keys, :provider, unique: true
  end
end
