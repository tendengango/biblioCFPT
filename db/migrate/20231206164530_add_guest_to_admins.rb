class AddGuestToAdmins < ActiveRecord::Migration[6.0]
  def change
    add_column :admins, :guest, :boolean
  end
end
