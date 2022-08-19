class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.references :likable, polymorphic: true
      t.timestamps
    end
    add_index :likes, [:likable_id, :likable_type]
  end
end
