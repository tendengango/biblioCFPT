class CreateLibrarians < ActiveRecord::Migration[6.0]
  def change
    create_table :librarians do |t|
      t.string :name
      t.string :email
      t.string :password
      t.string :approved

      t.timestamps
    end
  end
end
