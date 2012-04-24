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

  def reset
    @action_list = ActionList.find(params[:id])

    user_state = current_user.user_state

    user_state.reset(@action_list.id)

    notice = nil
    if not user_state.save
      notice = user_state.errors.full_messages.join("\n")
    end

    @content = @action_list.datum.content
    @highlight_start = 0
    @highlight_length = 0

    respond_to do |format|
      format.json {
        render :partial => "shared/content", :notice => notice
      }
    end
  end

  def execute
    action_list_id = params[:id]

    user_state = current_user.user_state

    if user_state.invalid?
      user_state.reset_count(action_list_id)
    else
      if not user_state.in_progress?
        user_state.reset_count(action_list_id)
      end

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

    @content = user_state.temp_current_data
    @highlight_start = user_state.temp_highlight_start
    @highlight_length = user_state.temp_highlight_length
    @current_position = user_state.current_position
    @last_mark_position = user_state.last_mark_position

    notice = nil
    if not user_state.save
      notice = user_state.errors.full_messages.join("\n")
      print "NOTICE: " + notice
    end

    respond_to do |format|
      format.json {
        render :partial => "shared/content", :notice => notice
      }
    end
  end
end
