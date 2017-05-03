class CreatePaths < ActiveRecord::Migration[5.0]
  def change
    create_table :paths do |t|
      t.integer :degree_id
      t.string :start_quarter
      t.integer :course_load
      t.integer :in_class
      t.integer :online

      t.timestamps
    end
  end
end
