class DataController < ApplicationController
  # GET /data/1
  # GET /data/1.json
  def show
    @datum = Datum.find(params[:id])

    user_state = current_user.user_state

    if not current_user.nil? and @datum.action_list.id == user_state.current_action_list_id and not user_state.temp_current_data.nil?
      @user_state = user_state
    else
      @user_state = UserState.new
      @user_state.reset(@datum.action_list.id)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @datum }
    end
  end

  # GET /data/new
  # GET /data/new.json
  def new
    @datum = Datum.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @datum }
    end
  end

  # GET /data/1/edit
  def edit
    @datum = Datum.find(params[:id])
  end

  # POST /data
  # POST /data.json
  def create
    @datum = Datum.new(params[:datum])
    @datum.action_list = ActionList.new(:name => "Empty")
    @datum.action_list.datum = @datum
    @datum.user = current_user
    respond_to do |format|
      if not @datum.action_list.save
        format.html { render action: "new" }
        format.json { render json: @datum.action_list.errors, status: :unprocessable_entity }
      elsif not @datum.save
        format.html { render action: "new" }
        format.json { render json: @datum.errors, status: :unprocessable_entity }
      else
        format.html { redirect_to @datum, notice: 'Datum was successfully created.' }
        format.json { render json: @datum, status: :created, location: @datum }
      end
    end
  end
  
  # PUT /data/1
  # PUT /data/1.json
  def update
    @datum = Datum.find(params[:id])
    verify_user(@datum.user.id)

    respond_to do |format|
      if @datum.update_attributes(params[:datum])
        format.html { redirect_to @datum, notice: 'Datum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data/1
  # DELETE /data/1.json
  def destroy
    @datum = Datum.find(params[:id])
    verify_user(@datum.user.id)
    @datum.destroy

    respond_to do |format|
      format.html { redirect_to data_url }
      format.json { head :no_content }
    end
  end
end
