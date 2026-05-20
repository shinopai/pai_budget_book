class CreateAssets < ActiveRecord::Migration[8.0]
  def change
    create_table :assets do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.integer :initial_amount, null: false, default: 0

      t.timestamps
    end
  end
end
