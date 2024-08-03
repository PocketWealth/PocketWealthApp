class CreateAccounts < ActiveRecord::Migration[7.2]
  def change
    create_table :accounts do |t|
      t.string :name
      t.integer :type
      t.boolean :transaction_managed, default: false
      t.decimal :cash, default: 0
      t.text :description
      t.string :financial_institution

      t.timestamps
    end
  end
end
