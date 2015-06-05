class EntityDecorator < Draper::Decorator
  delegate_all

  def rank
    1
  end

  def score
    latest_score
  end

end
