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

    current_user.current_action_list_id = @action_list.id
    current_user.current_action_list_index = 0
    current_user.temp_current_data = nil
    current_user.temp_highlight_start = 0
    current_user.temp_highlight_length = 0

    current_user.save

    @content = @action_list.datum.content
    @highlight_start = 0
    @highlight_length = 0

    respond_to do |format|
      format.json {
        render :partial => "shared/content"
      }
    end
  end
end
