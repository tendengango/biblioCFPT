class CreateCheckouts < ActiveRecord::Migration[6.0]
  def change
    create_table :checkouts do |t|
      t.date :issue_date
      t.date :return_date
      t.integer :validity
      t.belongs_to :student, null: false, foreign_key: true
      t.belongs_to :book, null: false, foreign_key: true
    end
  end
end
