class ActionListsController < ApplicationController
  def clear
    @action_list = ActionList.find(params[:id])
    verify_user(@action_list.datum.user.id)

    @action_list.action_types.each do |x|
      x.destroy
    end

    @user_state = current_user.user_state
    @user_state.reset(@action_list.id)
    
    if not @user_state.save
      raise @user_state.errors.full_messages.to_s
    end

    render_status(0)
  end

  def reset
    @action_list = ActionList.find(params[:id])

    user_state = current_user.user_state

    user_state.reset(@action_list.id)

    notice = nil
    if not user_state.save
      notice = user_state.errors.full_messages.join("\n")
    end

    render_status(0)
  end

  def keystrokes
    @action_list = ActionList.find(params[:id])
    user_state = current_user.user_state

    switch_action_list(@action_list.id)
    verify_user(@action_list.datum.user.id)

    success_key_count = 0

    key_values = params[:keys].values
    key_values.each do |keys|
      key_number = (keys["keydown"] or keys["keypress"]).to_i
      if keys.include?("keydown")
        key_type = :keydown
      elsif keys.include?("keypress")
        key_type = :keypress
      else
        raise "Key must be keypress or keydown"
      end

      if key_type == :keydown
        action_type = SpecialKeyAction::create(key_number, @action_list)
      elsif key_type == :keypress
        action_type = KeyPressAction::create(key_number, @action_list)
      end

      if not action_type.nil?

        action_type.arguments.each do |arg|
          if not arg.save
            raise "Cannot save arg: " + arg.errors.full_messages.to_s
          end
        end
        
        position = user_state.current_action_list_index
        @action_list.action_types.each do |a|
          # TODO: what if some positions don't get saved successfully? corruption?
          if a.position >= position
            a.position = a.position + 1
            if not a.save
              raise "Cannot save action_type while updating position: " + a.errors.full_messages.to_s
            end
          end
        end

        action_type.position = position
        if not action_type.save
          raise "Cannot save action_type: " + action_type.errors.full_messages.to_s
        end
        
        success_key_count += 1
      end
    end

    render_status(success_key_count)
  end

  def status
    @action_list = ActionList.find(params[:id])

    render_status(0)
  end

  def execute
    @action_list = ActionList.find(params[:id])

    render_status(1)
  end

  def render_status(execute_count)
    # if execute_count > 0, execute that many action_types. then render
    # content, info and the sidebar, passing it back as json
    if execute_count > 0
      switch_action_list(@action_list.id)

      user_state = current_user.user_state
    end
    
    execute_count.times do |i|
      if user_state.current_action_list_index >= user_state.current_action_list.action_types.count
        user_state.current_action_list_index = 0
      end
      
      if user_state.invalid?
        user_state.reset_count(@action_list.id)
      else
        current_action_list = user_state.current_action_list
        
        current_action_type = current_action_list.action_types[user_state.current_action_list_index]

        begin
          current_action_type.process(user_state, current_action_type.arguments)
        rescue RuntimeError => e
          @errors = "Error: " + e.to_s
          user_state.current_action_list_index = 0
        else
          user_state.current_action_list_index += 1
        end
      end
      
      if not user_state.save
        raise user_state.errors.full_messages.join("\n")
      end

    end
    
    if current_user.nil? or current_user.user_state.current_action_list.id != @action_list.id
      @user_state = UserState.new
      @user_state.reset(@action_list.id)
    else
      @user_state = current_user.user_state
    end

    respond_to do |format|
      format.json {
        render :partial => "shared/content"
      }
    end

  end
end
