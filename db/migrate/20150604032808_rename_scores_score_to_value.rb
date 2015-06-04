class RenameScoresScoreToValue < ActiveRecord::Migration
  def change
    rename_column :scores, :score, :value
  end
end
