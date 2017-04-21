class CreateCourseFrequencies < ActiveRecord::Migration[5.0]
  def change
    create_table :course_frequencies do |t|
      t.string :frequency

      t.timestamps
    end
  end
end
