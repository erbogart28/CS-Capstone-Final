class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.integer :people_soft_id
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
