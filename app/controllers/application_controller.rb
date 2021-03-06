# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # :secret => '0069c6b15e17ba43821b85f002c589d4'
  before_filter :login_required

  helper_method :current_user, :logged_in?

  private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    @current_user = current_user_session && current_user_session.user
  end

  def logged_in?
    !current_user.nil?
  end

  def login_required
    redirect_to new_user_session_url unless current_user
  end

end

