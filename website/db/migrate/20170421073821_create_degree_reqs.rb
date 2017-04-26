class CreateDegreeReqs < ActiveRecord::Migration[5.0]
  def change
    create_table :degree_reqs do |t|
      t.integer :course_id

      t.timestamps
    end
  end
end
