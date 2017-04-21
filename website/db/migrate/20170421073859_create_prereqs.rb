class CreatePrereqs < ActiveRecord::Migration[5.0]
  def change
    create_table :prereqs do |t|
      t.integer :course_id
      t.integer :prereq_course_id

      t.timestamps
    end
  end
end
