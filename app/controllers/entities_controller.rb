class EntitiesController < ApplicationController
  include EntitiesBase

  respond_to :html

  def new
    @score_saver = ScoreSaver.new(score_saver_params)
  end

  def create
    @score_saver = ScoreSaver.new(score_saver_params(params))

    if @score_saver.save
      respond_with @score_saver.entity.decorate
    else
      render :new
    end
  end
end
