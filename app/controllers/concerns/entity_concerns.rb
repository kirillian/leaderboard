module Concerns
  module EntityConcerns
    extend ActiveSupport::Concern

    included do
      def score_saver_params(params)
        params.permit(:name, :score)
      end

      def search_params(params)
        default_search_params.merge params.permit(:size, :offset)
      end

      def default_search_params
        ActionController::Parameters.new(size: 10, offset: 0)
      end
    end
  end
end
