class ContributionsController < ApplicationController
  # GET /contributions
  # GET /contributions.json
  def index
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @report = Report.find(params[:report_id])
    @contributions = @report.contributions.all

    respond_to do |format|
      format.html {render :layout => 'fullwidth'} # index.html.erb
      format.json { render json: @contributions }
    end
  end

  # GET /contributions/1
  # GET /contributions/1.json
  def show
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @report = Report.find(params[:report_id])
    @contribution = Contribution.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contribution }
    end
  end

  # GET /contributions/new
  # GET /contributions/new.json
  def new
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @report = Report.find(params[:report_id])
    @contribution = Contribution.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contribution }
    end
  end

  # GET /contributions/1/edit
  def edit
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @report = Report.find(params[:report_id])
    @contribution = Contribution.find(params[:id])
  end

  # POST /contributions
  # POST /contributions.json
  def create
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @report = Report.find(params[:report_id])
    @contribution = Contribution.new(params[:contribution])
    @contribution.report_id = @report.id
    @contribution.filer_id = @filer.id

    respond_to do |format|
      if @contribution.save
        format.html { redirect_to user_filer_report_contributions_path(@user, @filer, @report), notice: 'Contribution was successfully created.' }
        format.json { render json: @contribution, status: :created, location: @contribution }
      else
        format.html { render action: "new" }
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contributions/1
  # PUT /contributions/1.json
  def update
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @report = Report.find(params[:report_id])
    @contribution = Contribution.find(params[:id])

    respond_to do |format|
      if @contribution.update_attributes(params[:contribution])
        format.html { redirect_to user_filer_report_contributions_path(@user, @filer, @report), notice: 'Contribution was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contributions/1
  # DELETE /contributions/1.json
  def destroy
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @report = Report.find(params[:report_id])
    @contribution = Contribution.find(params[:id])
    @contribution.destroy unless ! @contribution.filer.user_id == @user.id

    respond_to do |format|
      format.html { redirect_to user_filer_report_contributions_path(@user, @filer, @report), notice: 'Contribution was deleted.' }
      format.json { head :no_content }
    end
  end
end
