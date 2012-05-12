class ActionTypesController < ApplicationController
  # GET /action_types/1
  # GET /action_types/1.json
  def show
    @action_type = ActionType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @action_type }
    end
  end

  # GET /action_types/new
  # GET /action_types/new.json
  def new
    switch_action_list(params[:action_list_id])
    
    @action_list = current_user.user_state.current_action_list
    
    @action_type = SearchActionType.new(:action_list => @action_list,
                                        :position => params[:position].to_i)
    render_new
  end

  def render_new
    respond_to do |format|
      format.html { render :new }
      format.json { render json: @action_type }
    end

  end

  # GET /action_types/1/edit
  def edit
    @action_type = ActionType.find(params[:id])
    @action_list = @action_type.action_list
    switch_action_list(@action_list.id)
  end

  def create_current
    #fill in some missing params from user_state
    @action_type = ActionType.factory_create(params[:action_type][:type], params)
    user_state = current_user.user_state
    switch_action_list(user_state.current_action_list.id)
    @action_type.action_list = user_state.current_action_list
    @action_type.position = user_state.current_action_list_index

    verify_user(@action_type.action_list.datum.user.id)

    increment_and_save_positions(@action_type.position)

    @errors = nil
    @user_state = user_state
    if not @action_type.save
      @errors = @action_type.errors.full_messages.join("\n")
    else
      count = @user_state.commands.count
      InsertCommand.new do |command|
        command.user_state = @user_state
        command.order = count
        command.insert_index = @user_state.current_action_list_index
        command.save
      end

      user_state.current_action_list_index = user_state.current_action_list_index + 1
      if not user_state.save
        raise "Error updating user state position in index"
      end
    end
    
    respond_to do |format|
      format.json { render :partial => "shared/content" }
    end
  end

  # POST /action_types
  # POST /action_types.json
  def create
    @action_type = ActionType.factory_create(params[:action_type][:type], params)
    verify_user(@action_type.action_list.datum.user.id)

    increment_and_save_positions(@action_type.position)

    respond_to do |format|
      if @action_type.save
        InsertCommand.new do |command|
          command.user_state = current_user.user_state
          command.order = current_user.user_state.commands.count
          command.insert_index = @action_type.position
          command.save
        end

        format.html { redirect_to @action_type.action_list.datum, notice: 'Action type was successfully created.' }
        format.json { render json: @action_type, status: :created, location: @action_type }
      else
        format.html { render_new }
        format.json { render json: @action_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /action_types/1
  # PUT /action_types/1.json
  def update
    @action_type = ActionType.find(params[:id])
    verify_user(@action_type.action_list.datum.user.id)

    respond_to do |format|
      new_action_type = ActionType.factory_create(params[:action_type][:type], params)
      if new_action_type.save
        @action_type.destroy
        format.html { redirect_to @action_type.action_list.datum, notice: 'Action type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @action_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /action_types/1
  # DELETE /action_types/1.json
  def destroy
    @action_type = ActionType.find(params[:id])
    verify_user(@action_type.action_list.datum.user.id)
    @action_type.destroy

    respond_to do |format|
      format.html { redirect_to action_types_url }
      format.json { head :no_content }
    end
  end

  def select_changed
    action_type_type = params[:action_type][:type]
    action_type_id = params[:action_type][:action_type_id]
    action_list_id = params[:action_list_id]
    switch_action_list(action_list_id)
    @action_list = ActionList.find(action_list_id)
    @action_type = ActionType.find_by_id(action_type_id)
    
    if @action_type.nil?
      @action_type = ActionType.factory_create(action_type_type)
      @action_type.action_list = @action_list
    end

    respond_to do |format|
      format.html {
        render :partial => true
      }
    end
  end

  protected
  def method_missing(meth, *arg, &blk)
    if /_action_type_url$/ =~ meth
      url_for(:controller => :action_types)
    else
      super
    end
  end

  protected
  def increment_and_save_positions(position)
    action_types_with_greater_position = ActionType.where "position >= " + position.to_s
    action_types_with_greater_position.each do |action_type|
      action_type.position = action_type.position + 1
      if not action_type.save
        raise "Unable to save ActionType while incrementing position"
      end
    end

  end
end
