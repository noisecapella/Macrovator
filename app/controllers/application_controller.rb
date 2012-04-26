class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if (session[:user_id] and User.exists?(session[:user_id]))
  end

  private
  def verify_user(user_id)
    if current_user.id != user_id
      raise "User #{current_user.id} is attempting to edit tables that they don't own"
    end
  end

  helper_method :current_user
end
