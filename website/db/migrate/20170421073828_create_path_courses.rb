class CreatePathCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :path_courses do |t|
      t.integer :path_id
      t.integer :course_id
      t.integer :year
      t.string :course_term

      t.timestamps
    end
  end
end
