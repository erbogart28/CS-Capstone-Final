class AddHistoryToCourse < ActiveRecord::Migration[5.0]
	def change
		add_column :courses, :course_history, :varchar
	end
end
