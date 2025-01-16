class CreatePermissionsRolesJoinTable < ActiveRecord::Migration[8.0]
  def change
    create_join_table :permissions, :roles, column_options: { null: false, foreign_key: true } do |t|
      t.index [ :permission_id, :role_id ], unique: true
    end
  end
end
