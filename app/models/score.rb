class Score < ActiveRecord::Base
  belongs_to :entity

  validates :value, presence: true
end
