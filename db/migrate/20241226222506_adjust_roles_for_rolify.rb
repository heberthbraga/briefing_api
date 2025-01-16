class AdjustRolesForRolify < ActiveRecord::Migration[8.0]
  def change
    change_table :roles do |t|
      # Add polymorphic fields for rolify
      t.string :resource_type
      t.bigint :resource_id

      # Ensure combination of resource_type and resource_id can be indexed for performance
      t.index [ :resource_type, :resource_id ]
    end
  end
end
