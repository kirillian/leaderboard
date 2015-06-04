class ChangeScoresValueTypeToString < ActiveRecord::Migration
  def change
    change_column :scores, :value, :string, null: false
  end
end
