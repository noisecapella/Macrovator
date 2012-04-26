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

  private
  def switch_action_list(action_list_id)
    # TODO: if current_user is nil, make them log in first
    user_state = current_user.user_state
    if user_state.current_action_list.nil? or user_state.current_action_list.id != action_list_id
      user_state.reset(action_list_id)
      if not user_state.save
        raise "Problem updating user temporary information"
      end
    end
  end

  helper_method :current_user
end
