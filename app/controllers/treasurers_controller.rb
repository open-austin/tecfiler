class TreasurersController < ApplicationController

  # GET /treasurers
  # GET /treasurers.json
  # def index
    # @user = current_user
    # @filer = Filer.get(params[:filer_id])
    # @treasurer = @filer.treasurer

    # respond_to do |format|
      # format.html # index.html.erb
      # format.json { render json: @treasurers }
    # end
  # end

  # GET /treasurers/1
  # GET /treasurers/1.json
  # def show
    # @user = current_user
    # @filer = Filer.get(params[:filer_id])
    # @treasurer = Treasurer.get(params[:id])

    # respond_to do |format|
      # format.html # show.html.erb
      # format.json { render json: @treasurer }
    # end
  # end

  # GET /treasurers/new
  # GET /treasurers/new.json
  def new
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @treasurer = Treasurer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @treasurer }
    end
  end

  # GET /treasurers/1/edit
  def edit
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @treasurer = Treasurer.find(params[:id])
  end

  # POST /treasurers
  # POST /treasurers.json
  def create
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @treasurer = Treasurer.new(params[:treasurer])
    @treasurer.user_id = @user.id
    @treasurer.filer_id = @filer.id

    respond_to do |format|
      if @treasurer.save
        format.html { redirect_to root_path, notice: 'Treasurer was successfully created.' }
        format.json { render json: @treasurer, status: :created, location: @treasurer }
      else
        format.html { render action: "new" }
        format.json { render json: @treasurer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /treasurers/1
  # PUT /treasurers/1.json
  def update
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @treasurer = Treasurer.find(params[:id])

    respond_to do |format|
      if @treasurer.update_attributes(params[:treasurer])
        format.html { redirect_to root_path, notice: 'Treasurer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @treasurer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /treasurers/1
  # DELETE /treasurers/1.json
  # def destroy
    # @user = current_user
    # @filer = Filer.get(params[:filer_id])
    # @treasurer = Treasurer.get(params[:id])
    # @treasurer.destroy

    # respond_to do |format|
      # format.html { redirect_to treasurers_url }
      # format.json { head :no_content }
    # end
  # end

end
