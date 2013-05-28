class FilersController < ApplicationController

  # GET /filers
  # GET /filers.json
  # def index
    # @user = current_user
    # @filer = @user.filer

    # respond_to do |format|
      # format.html # index.html.erb
      # format.json { render json: @filers }
    # end
  # end

  # GET /filers/1
  # GET /filers/1.json
  # def show
    # @user = current_user
    # @filer = Filer.get(params[:id])
    # @treasurer = @filer.treasurer

    # respond_to do |format|
      # format.html # show.html.erb
      # format.json { render json: @filer }
    # end
  # end

  # GET /filers/new
  # GET /filers/new.json
  def new
    @user = current_user
    @filer = Filer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @filer }
    end
  end

  # GET /filers/1/edit
  def edit
    @user = current_user
    @filer = Filer.find(params[:id])
  end

  # POST /filers
  # POST /filers.json
  def create
    @user = current_user
    @filer = Filer.new(params[:filer])
    @filer.user_id = @user.id
    @treasurer = @filer.treasurer

    respond_to do |format|
      if @filer.save
        format.html { redirect_to root_path, notice: 'Filer was successfully created.' }
        format.json { render json: @filer, status: :created, location: @filer }
      else
        format.html { render action: "new" }
        format.json { render json: @filer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /filers/1
  # PUT /filers/1.json
  def update
    @user = current_user
    @filer = Filer.find(params[:id])
    @treasurer = @filer.treasurer

    respond_to do |format|
      if @filer.update_attributes(params[:filer])
        format.html { redirect_to root_path, notice: 'Filer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @filer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /filers/1
  # DELETE /filers/1.json
  # def destroy
    # @user = current_user
    # @filer = Filer.get(params[:id])
    # @filer.destroy

    # respond_to do |format|
      # format.html { redirect_to filers_url }
      # format.json { head :no_content }
    # end
  # end

end
