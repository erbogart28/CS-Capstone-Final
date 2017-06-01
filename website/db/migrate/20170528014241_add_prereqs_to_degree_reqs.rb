class AddPrereqsToDegreeReqs < ActiveRecord::Migration[5.0]
  def change
    add_column :degree_reqs, :prereqs, :varchar
  end
end
