class CreateRolesUsersJoinTable < ActiveRecord::Migration[8.0]
  def change
    create_join_table :roles, :users, column_options: { null: false, foreign_key: true } do |t|
      t.index [ :role_id, :user_id ], unique: true
    end
  end
end
