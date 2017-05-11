class DropCourseDeliveryTermFrequency < ActiveRecord::Migration[5.0]
  def change
	drop_table :course_deliveries
	drop_table :course_frequencies
	drop_table :course_terms
  end
end
