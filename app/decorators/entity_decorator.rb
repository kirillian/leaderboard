class EntityDecorator < Draper::Decorator
  delegate_all

  def score
    latest_score
  end

end
