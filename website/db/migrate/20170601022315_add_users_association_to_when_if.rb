class AddUsersAssociationToWhenIf < ActiveRecord::Migration[5.0]
  def change
    add_column :when_ifs, :user_id, :integer
  end
end
