class ActionTypesController < ApplicationController
  # GET /action_types
  # GET /action_types.json
  def index
    @action_types = ActionType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @action_types }
    end
  end

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
    @action_list = ActionList.find(params[:action_list_id])
    @action_type = ActionType.new(:action_list => @action_list,
                                  :action_type => SearchAction::Id)
    @action_type.arguments = populate_arguments(@action_type.action_type)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @action_type }
    end
  end

  # GET /action_types/1/edit
  def edit
    
    @action_type = ActionType.find(params[:id])
    @action_list = @action_type.action_list
  end

  # POST /action_types
  # POST /action_types.json
  def create
    @action_type = ActionType.new(params[:action_type])

    respond_to do |format|
      if @action_type.save
        format.html { redirect_to @action_type, notice: 'Action type was successfully created.' }
        format.json { render json: @action_type, status: :created, location: @action_type }
      else
        format.html { render action: "new" }
        format.json { render json: @action_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /action_types/1
  # PUT /action_types/1.json
  def update
    @action_type = ActionType.find(params[:id])

    respond_to do |format|
      if @action_type.update_attributes(params[:action_type])
        format.html { redirect_to @action_type, notice: 'Action type was successfully updated.' }
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
    @action_type.destroy

    respond_to do |format|
      format.html { redirect_to action_types_url }
      format.json { head :no_content }
    end
  end

  def select_changed
    action_type_type = params[:action_type][:action_type]
    action_type_id = params[:action_type][:action_type_id]

    # note that this isn't saved here
    @action_list = ActionList.find_by_id(params[:id])
    @action_type = ActionType.find_by_id(action_type_id)
    
    if @action_list.nil? or @action_type.nil?
      @action_type = ActionType.new(:action_type => action_type_type)
      @action_type.action_list = @action_list
      @action_type.arguments = populate_arguments(@action_type.action_type)
    end

    respond_to do |format|
      format.html {
        render :partial => true
      }
    end
  end



  private
  def populate_arguments(action_type_id)
    arguments_list = Constants::ActionMap[action_type_id.to_i]::Arguments

    # create temporary arguments to contain data and create fields
    arguments = arguments_list.map do |pair| 
      Argument.new(:key => pair[:key], :value => pair[:default_value])
    end

  end
end
