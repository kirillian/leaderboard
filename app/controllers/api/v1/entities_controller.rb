module API
  module V1
    class EntitiesController < APIController
      include Concerns::EntityConcerns

      before_action only: :index do |_controller|
        render_bad_request if dataset_requested_too_large?(search_params(params)[:size])
      end

      before_action only: :index do |_controller|
        render_not_found if offset_out_of_range?(search_params(params)[:offset])
      end

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

      protected

      def dataset_requested_too_large?(requested_size)
        requested_size.to_i > 100
      end

      def offset_out_of_range?(requested_offset)
        requested_offset.to_i > Entity.count
      end
    end
  end
end
