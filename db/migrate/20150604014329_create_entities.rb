class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities do |t|
      t.string :name, null: false
      t.timestamps null: false
    end

    add_index :entities, :name, unique: true
  end
end
