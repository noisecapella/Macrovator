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

    render_status
  end

  def reset
    @action_list = ActionList.find(params[:id])

    user_state = current_user.user_state

    user_state.reset(@action_list.id)

    notice = nil
    if not user_state.save
      notice = user_state.errors.full_messages.join("\n")
    end

    render_status
  end

  def keystrokes
    @action_list = ActionList.find(params[:id])
    user_state = current_user.user_state

    switch_action_list(@action_list.id)
    verify_user(@action_list.datum.user.id)

    success_key_count = 0

    any_alter_command_in_place = false
    key_values = params[:keys].values
    key_values.each do |keys|
      key_number = (keys["keydown"] or keys["keypress"]).to_i
      if keys.include?("keydown")
        key_type = :keydown
      elsif keys.include?("keypress")
        if keys.include?("ctrl") or keys.include?("meta") or keys.include?("alt")
          key_type = :modified_keypress
        elsif key_number < 32
          key_type = nil
        else
          key_type = :keypress
        end
      else
        raise "Key must be keypress or keydown"
      end

      alter_command_in_place = false
      if key_type == :keydown and SpecialKeyActionType::KeytypeMap.include?(key_number)
        action_type = SpecialKeyActionType.new(:keytype => key_number, :action_list => @action_list)
      elsif key_type == :keypress
        current_index = user_state.current_action_list_index

        if @action_list.action_types.count > 0 and current_index > 0 and current_index <= @action_list.action_types.count and @action_list.action_types[current_index - 1].is_keypress?
          action_type = @action_list.action_types[current_index - 1]
          action_type.keys += key_number.chr
          alter_command_in_place = true
          any_alter_command_in_place = true
        else
          action_type = KeyPressActionType.new(:keys => key_number.chr, :action_list => @action_list)
        end
      elsif key_type == :modified_keypress
        metakeys = ModifiedKeyActionType::make_metakeys_value(keys.include?("ctrl"), keys.include?("meta"), keys.include?("alt"))
        action_type = ModifiedKeyActionType::create(:keys => key_number.chr, :metakeys => metakeys, :action_list => @action_list)
      end

      if not action_type.nil?
        
        if not alter_command_in_place
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
        end
        if not action_type.save
          raise "Cannot save action_type: " + action_type.errors.full_messages.to_s
        else
          InsertCommand.new do |command|
            command.user_state = current_user.user_state
            command.order = current_user.user_state.commands.count
            command.insert_index = action_type.position
            command.save
          end
        end
        
        if not any_alter_command_in_place
          success_key_count += 1
        end
      end
    end

    
    render_status(true, success_key_count, any_alter_command_in_place)
  end

  def status
    @action_list = ActionList.find(params[:id])

    render_status
  end

  def execute
    @action_list = ActionList.find(params[:id])

    render_status(true, 1, false)
  end

  def execute_rest
    @action_list = ActionList.find(params[:id])
    user_state = current_user.user_state
    switch_action_list(@action_list.id)
    render_status(true, :rest, false)
  end

  def delete_current_action_type
    @action_list = ActionList.find(params[:id])
    user_state = current_user.user_state
    switch_action_list(@action_list.id)
    
    index = user_state.current_action_list_index
    if index >= 0 and index < user_state.current_action_list.action_types.count
      action_type = user_state.current_action_list.action_types[index]
      action_type.destroy
    end

    render_status
  end

  protected
  def inner_loop(user_state)
    if user_state.current_action_list_index == 0
      user_state.reset(@action_list.id)
    end
    
    if user_state.invalid?
      user_state.reset(@action_list.id)
    else
      if not user_state.in_progress?
        user_state.reset_count(@action_list.id)
      end
      
      current_action_list = user_state.current_action_list
      
      current_action_type = current_action_list.action_types[user_state.current_action_list_index]
      
      begin
        current_action_type.process(user_state)
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
    
    if not @errors.nil?
      raise @errors
    end
  end
  

  protected
  def render_status(do_execute = false, execute_count = 0, any_alter_command_in_place = false)
    @errors = nil


    user_state = nil
    if do_execute
      switch_action_list(@action_list.id)

      user_state = current_user.user_state

      if any_alter_command_in_place
        index = user_state.current_action_list_index
        user_state.reset(@action_list.id)
        if execute_count != :rest
          execute_count += index
        end
      end
    end

    begin
      if execute_count == :rest
        while true do
          inner_loop(user_state)
        end
      else
        execute_count.times do |i|
          inner_loop(user_state)
        end
      end
    rescue RuntimeError => e
      @errors = e.to_s
    end
    
    if current_user.nil? or current_user.user_state.current_action_list.id != @action_list.id
      @user_state = UserState.new
      @user_state.reset(@action_list.id)
      @user_state.last_errors = @errors
    else
      @user_state = current_user.user_state
      @user_state.last_errors = @errors

      if not @user_state.save
        @user_state.errors += "\nCannot write errors to user_state"
      end
    end

    respond_to do |format|
      format.json {
        render :partial => "shared/content"
      }
    end

  end
end
