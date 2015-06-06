module API
  class APIController < ApplicationController
    respond_to :json

    protect_from_forgery with: :null_session

    def record_not_found
      render status: :not_found, nothing: true
    end

    protected

    def method_missing(method, *args, &block)
      if method =~ /render_(\w+)/
        render status: Regexp.last_match(1).to_sym, nothing: true
      else
        super
      end
    end
  end
end
