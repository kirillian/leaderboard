module API
  module V1
    class EntitiesController < APIController
      include EntitiesBase

      def create
        @score_saver = ScoreSaver.new(score_saver_params(params))

        if @score_saver.save
          render status: :ok, nothing: true
        else
          render status: :internal_server_error, nothing: true
        end
      end

      def destroy
        @entity = Entity.find_by(name: params[:name])

        render(status: :not_found, nothing: true) if @entity.nil?; return if performed?

        if @entity.destroy
          render status: :ok, nothing: true
        else
          render status: :internal_server_error, nothing: true
        end
      end
    end
  end
end
