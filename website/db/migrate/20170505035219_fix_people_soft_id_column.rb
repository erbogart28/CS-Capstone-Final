class FixPeopleSoftIdColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :courses, :people_soft_id, :course_code
    change_column :courses, :course_code, :varchar
  end
end
