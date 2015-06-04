class AddLatestScoreColumnToEntities < ActiveRecord::Migration
  def change
    add_column :entities, :latest_score, :string
  end
end
