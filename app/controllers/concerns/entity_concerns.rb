module Concerns
  module EntityConcerns
    extend ActiveSupport::Concern

    included do
      before_action only: :index do |_controller|
        render_bad_request if dataset_requested_too_large?(search_params(params)[:size])
      end

      before_action only: :index do |_controller|
        render_not_found if offset_out_of_range?(search_params(params)[:offset])
      end

      def score_saver_params(params)
        params.permit(:name, :score)
      end

      def search_params(params)
        default_search_params.merge params.permit(:size, :offset)
      end

      def default_search_params
        ActionController::Parameters.new(size: 10, offset: 0)
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
