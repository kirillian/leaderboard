class ScoreSaver
  attr_accessor :name, :score

  def initialize(params)
    @name = params[:name]
    @score = params[:score]
  end

  def entity
    Entity.find_or_create_by(:name)
  end

  def score
    entity.scores.build(score: score)
  end

  def save
    save!
  rescue StandardError => e
    false
  end

  def save!
    ActiveRecord::Base.transaction do
      entity.save!
      score.save!
      UpdateEntityLatestScore.perform_later entity.id
    end
  end
end
