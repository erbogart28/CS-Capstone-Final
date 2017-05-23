class AddPrereqsColumnToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :prereqs, :varchar
  end
end
