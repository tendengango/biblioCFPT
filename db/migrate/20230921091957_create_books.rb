class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :isbn
      t.string :title
      t.string :authors
      t.string :language
      t.date :published
      t.string :edition
      t.text :summary
      t.integer :quantity

      t.timestamps
    end
  end
end
