class CreateWhenIfs < ActiveRecord::Migration[5.0]
  def change
    create_table :when_ifs do |t|
      t.string :start_quarter
      t.string :degree_id
      t.string :concentration
      t.integer :course_load

      t.timestamps
    end
  end
end
