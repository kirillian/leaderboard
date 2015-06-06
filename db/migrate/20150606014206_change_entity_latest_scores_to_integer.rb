class ChangeEntityLatestScoresToInteger < ActiveRecord::Migration
  def up
    change_column :entities, :latest_score, 'integer USING latest_score::integer'
  end

  def down
    change_column :entities, :latest_score, 'varchar USING latest_score::varchar'
  end
end
