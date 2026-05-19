class CreateSubCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :sub_categories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
