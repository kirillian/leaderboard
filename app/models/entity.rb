class Entity < ActiveRecord::Base
  has_many :scores, dependent: :destroy

  validates :name, presence: true

  def self.with_rank
    select(Arel.star).select(Arel::Nodes::Over.new(row_number, window_over_latest_score_desc).as('rank').to_sql)
  end

  def self.window_over_latest_score_desc
    Arel::Nodes::Window.new.tap do |window|
      window.order(arel_table[:latest_score].desc)
    end
  end

  def self.row_number
    Arel::Nodes::SqlLiteral.new('row_number()')
  end
end
