class CreateInvites < ActiveRecord::Migration[6.1]
  def change
    create_table :invites do |t|
      t.integer :from_id
      t.integer :to_id
      t.boolean :accepted, boolean: false

      t.timestamps
    end

    add_foreign_key :invites, :users, column: :from_id
    add_foreign_key :invites, :users, column: :to_id

    add_index :invites, :from_id
    add_index :invites, :to_id
  end
end
