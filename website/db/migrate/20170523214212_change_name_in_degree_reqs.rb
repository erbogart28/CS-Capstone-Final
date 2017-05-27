class ChangeNameInDegreeReqs < ActiveRecord::Migration[5.0]
  def change
    rename_column :degree_reqs, :course_id, :course_code
    change_column :degree_reqs, :course_code, :varchar
    add_column :degree_reqs, :priority, :integer
  end
end
