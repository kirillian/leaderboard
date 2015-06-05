class UpdateEntityLatestScoreJob < ActiveJob::Base
  queue_as :default

  def perform(entity_id)
    entity = Entity.find_by(id: entity_id)

    entity.latest_score = entity.scores.order("created_at DESC").first.value
    entity.save!
  end
end
