class ActionListsController < ApplicationController
  # GET /action_lists
  # GET /action_lists.json
  def index
    @action_lists = ActionList.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @action_lists }
    end
  end

  # GET /action_lists/1
  # GET /action_lists/1.json
  def show
    @action_list = ActionList.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @action_list }
    end
  end

  # GET /action_lists/new
  # GET /action_lists/new.json
  def new
    @action_list = ActionList.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @action_list }
    end
  end

  # GET /action_lists/1/edit
  def edit
    @action_list = ActionList.find(params[:id])
  end

  # POST /action_lists
  # POST /action_lists.json
  def create
    @action_list = ActionList.new(params[:action_list])

    respond_to do |format|
      if @action_list.save
        format.html { redirect_to @action_list, notice: 'Action list was successfully created.' }
        format.json { render json: @action_list, status: :created, location: @action_list }
      else
        format.html { render action: "new" }
        format.json { render json: @action_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /action_lists/1
  # PUT /action_lists/1.json
  def update
    @action_list = ActionList.find(params[:id])

    respond_to do |format|
      if @action_list.update_attributes(params[:action_list])
        format.html { redirect_to @action_list, notice: 'Action list was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @action_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /action_lists/1
  # DELETE /action_lists/1.json
  def destroy
    @action_list = ActionList.find(params[:id])
    @action_list.destroy

    respond_to do |format|
      format.html { redirect_to action_lists_url }
      format.json { head :no_content }
    end
  end

  def clear
    @action_list = ActionList.find(params[:id])
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
    @action_list = ActionList.find_by_id(current_user.user_state.current_action_list_id)

    user_state = current_user.user_state
    
    params[:keys].values.each do |keys|
      key_number = keys.values.first.to_i
      key_type = keys.keys.first.to_sym

      action_type = nil
      if key_type == :keydown
        action_type = DirectionKeyAction::create(key_number, @action_list)
      else if key_number != 0
        action_type = KeyPressAction::create(key_number, @action_list)
      end

      if not action_type.nil?
        action_type.arguments.each { |arg|
          if not arg.save
            raise "Cannot save arg: " + arg.errors.full_messages.to_s
          end
          }
        if not action_type.save
          raise "Cannot save action_type: " + action_type.errors.full_messages.to_s
        end
      end
      end
    end
    
    render_status
  end

  def status
    @action_list = ActionList.find(params[:id])

    render_status
  end

  def execute
    @action_list = ActionList.find(params[:id])

    user_state = current_user.user_state

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

    render_status
  end

  def render_status
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
