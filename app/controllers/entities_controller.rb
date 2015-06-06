class EntitiesController < ApplicationController
  include Concerns::EntityConcerns

  respond_to :html

  def index
    @entities = Entity.with_rank
                .order(latest_score: :desc)
                .limit(search_params(params)[:size])
                .offset(search_params(params)[:offset]).decorate

    respond_with @entities
  end
end
