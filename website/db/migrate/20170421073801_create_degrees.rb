class CreateDegrees < ActiveRecord::Migration[5.0]
  def change
    create_table :degrees do |t|
      t.string :major
      t.string :concentration
      t.integer :degree_reqs_id

      t.timestamps
    end
  end
end
