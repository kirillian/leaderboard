module API
  class APIController < ApplicationController
    respond_to :json

    protect_from_forgery with: :null_session

    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def record_not_found
      render status: :not_found, nothing: true
    end

    def method_missing(method, *args, &block)
      if method =~ /render_(\w+)/
        render status: $1.to_sym, nothing: true
      else
        super
      end
    end
  end
end
