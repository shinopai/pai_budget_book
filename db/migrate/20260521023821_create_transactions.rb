class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :sub_category, null: false, foreign_key: true
      t.integer :amount, null: false
      t.integer :transaction_type, null: false
      t.date :transacted_at, null: false
      t.text :memo

      t.timestamps
    end
  end
end
