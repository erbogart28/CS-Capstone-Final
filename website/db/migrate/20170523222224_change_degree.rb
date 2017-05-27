class ChangeDegree < ActiveRecord::Migration[5.0]
  def change
    add_column :degree_reqs, :degree_id, :integer
    add_column :degree_reqs, :history, :varchar
  end
end
