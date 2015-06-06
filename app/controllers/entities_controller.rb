class EntitiesController < ApplicationController
  include Concerns::EntityConcerns

  respond_to :html

  def index
    @entities = Entity.select(Arel.star).with_rank
                .order('latest_score DESC')
                .limit(params[:size])
                .offset(params[:offset]).decorate

    respond_with @entities
  end
end
