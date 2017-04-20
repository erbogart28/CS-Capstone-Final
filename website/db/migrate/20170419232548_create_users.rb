class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :first
      t.string :last
      t.string :email
      t.string :school_id

      t.timestamps
    end
  end
end
