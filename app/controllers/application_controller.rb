class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def method_missing(method, *args, &block)
    if method =~ /render_(\w+)/
      render status: Regexp.last_match(1).to_sym, nothing: true
    else
      super
    end
  end
end
