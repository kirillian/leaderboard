class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :entity_id, null: false
      t.integer :score
      t.timestamps null: false
    end

    add_index :scores, :entity_id, :score
  end
end
