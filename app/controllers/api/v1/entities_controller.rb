module API
  module V1
    class EntitiesController < APIController
      include Concerns::EntityConcerns

      def index
        @entities = Entity.
          order("latest_score DESC").
          limit(params[:size]).
          offset(params[:offset]).decorate

        respond_with @entities
      end

      def show
        entity = Entity.find_by(name: params[:name])

        raise ActiveRecord::RecordNotFound if entity.nil?

        @entity = entity.decorate

        respond_with @entity
      end

      def create
        @score_saver = ScoreSaver.new(score_saver_params(params))

        if @score_saver.save
          render_ok
        else
          render_internal_server_error
        end
      end

      def destroy
        @entity = Entity.find_by(name: params[:name])

        raise ActiveRecord::RecordNotFound if @entity.nil?

        if @entity.destroy
          render_ok
        else
          render_internal_server_error
        end
      end
    end
  end
end
