class AddGuestToStudents < ActiveRecord::Migration[6.0]
  def change
    add_column :students, :guest, :boolean
  end
end
