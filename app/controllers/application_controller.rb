class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def redirect_to_named_route
    redirect_to "/download-excel-financial-statements" ,:status => 301
  end

end
