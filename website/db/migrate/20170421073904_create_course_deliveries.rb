class CreateCourseDeliveries < ActiveRecord::Migration[5.0]
  def change
    create_table :course_deliveries do |t|
      t.integer :course_id
      t.string :course_term
      t.string :course_frequency

      t.timestamps
    end
  end
end
