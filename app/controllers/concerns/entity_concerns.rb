module Concerns
  module EntityConcerns
    extend ActiveSupport::Concern

    included do
      def score_saver_params(params)
        params.permit(:name, :score)
      end
    end
  end
end
