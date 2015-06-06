module API
  module V1
    class EntitiesController < APIController
      include Concerns::EntityConcerns

      def index
        @entities = Entity.with_rank
                    .order(latest_score: :desc)
                    .limit(search_params(params)[:size])
                    .offset(search_params(params)[:offset]).decorate

        respond_with @entities
      end

      def show
        entity = Entity.with_rank.where(name: params[:name]).order(latest_score: :desc).first

        fail ActiveRecord::RecordNotFound if entity.nil?

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

        fail ActiveRecord::RecordNotFound if @entity.nil?

        if @entity.destroy
          render_ok
        else
          render_internal_server_error
        end
      end
    end
  end
end
