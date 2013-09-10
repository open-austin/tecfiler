class ReportsController < ApplicationController
  # GET /reports
  # GET /reports.json
  def index
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @reports = @filer.reports.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reports }
    end
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @report = Report.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @report }
    end
  end

  # GET /reports/new
  # GET /reports/new.json
  def new
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @report = Report.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @report }
    end
  end

  # GET /reports/1/edit
  def edit
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @report = Report.find(params[:id])
  end

  # POST /reports
  # POST /reports.json
  def create
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @report = Report.new(params[:report])
    @report.user_id = @user.id
    @report.filer_id = @filer.id
    @report.treasurer = @user.treasurer

    respond_to do |format|
      if @report.save
        format.html { redirect_to root_path, notice: 'Report was successfully created.' }
        format.json { render json: @report, status: :created, location: @report }
      else
        format.html { render action: "new" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reports/1
  # PUT /reports/1.json
  def update
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @report = Report.find(params[:id])

    case params[:commit]
    when "Upload" 
      if @report.update_attributes(params[:report])
        @report.data_changed
        redirect_to root_path, notice: 'File was successfully uploaded.' 
      else
        render action: "edit"
      end
    else
      respond_to do |format|
        if @report.update_attributes(params[:report])
          @report.data_changed
          format.html { redirect_to root_path, notice: 'Report was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @report.errors, status: :unprocessable_entity }
        end
      end # respond_to do |format|
    end # case params[:commit]
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @report = Report.find(params[:id])
    @report.destroy

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Report was deleted.' }
      format.json { head :no_content }
    end
  end

  # POST
  def submit_report
    @user = current_user
    @report = Report.find(params[:id])
    @filer = @report.filer

    if @report.submitted
      redirect_to root_path, notice: 'Report was successfully submitted.'
    else
      redirect_to root_path, error: 'An error occurred.'
    end
  end

end
