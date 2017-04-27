class CreateCourseTerms < ActiveRecord::Migration[5.0]
  def change
    create_table :course_terms do |t|
      t.string :term

      t.timestamps
    end
  end
end
