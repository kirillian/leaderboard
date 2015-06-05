module EntitiesBase
  extend ActiveSupport::Concern

  included do
    def index
      @entities = Entity.
        order("score DESC").
        limit(params[:size]).
        offset(params[:offset]).decorate

      respond_with @entities
    end

    def show
      @entity = Entity.find_by(name: params[:name]).decorate
    end

    def create
      @score_saver = ScoreSaver.new(score_saver_params)
    end

    def score_saver_params(params)
      params.permit(:name, :score)
    end
  end
end
