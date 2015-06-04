class EntitiesController < ApplicationController
  include EntitiesBase

  respond_to :html

  def new
    @score_saver = ScoreSaver.new(score_saver_params)
  end
end
