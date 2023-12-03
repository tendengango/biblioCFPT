class AddAvailableQuantityToBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :available_quantity, :integer
  end
end
