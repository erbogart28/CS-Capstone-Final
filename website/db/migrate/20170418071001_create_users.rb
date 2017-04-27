class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :permission
      t.string :view_as
      t.string :first
      t.string :last
      t.string :email
      t.integer :degree_id
      t.integer :course_load
      t.integer :in_class
      t.integer :online
      t.integer :path_id
      t.integer :deleted

      t.timestamps
    end
  end
end
