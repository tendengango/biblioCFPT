class AddGuestToLibrarians < ActiveRecord::Migration[6.0]
  def change
    add_column :librarians, :guest, :boolean
  end
end
