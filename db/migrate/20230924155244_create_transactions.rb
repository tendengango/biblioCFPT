class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.string :isbn
      t.string :email
      t.boolean :checkout

      t.timestamps
    end
  end
end
