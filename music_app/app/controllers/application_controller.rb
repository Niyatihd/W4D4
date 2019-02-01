class ApplicationController < ActionController::Base
  def login!(user)
    session[:session_token] = user.session_token
  end

  def logout!(user)
    session[:session_token] = nil

    if current_user
      user.reset_session_token!
    end
  end

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def logged_in?
    !!current_user
  end
end
