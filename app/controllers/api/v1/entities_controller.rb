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
    end
  end
end
