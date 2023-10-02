class CreateStudents < ActiveRecord::Migration[6.0]
  def change
    create_table :students do |t|
      t.string :matricule
      t.string :email
      t.string :name
      t.string :password
      t.string :classname

      t.timestamps
    end
  end
end
