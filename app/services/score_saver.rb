class ScoreSaver
  attr_accessor :name, :value

  def initialize(params)
    @name = params[:name]
    @value = params[:score]
  end

  def entity
    @entity ||= Entity.find_or_initialize_by(name: name)
  end

  def score
    @score ||= entity.scores.build(value: value)
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
    end

    UpdateEntityLatestScoreJob.perform_later entity.id
  end
end
