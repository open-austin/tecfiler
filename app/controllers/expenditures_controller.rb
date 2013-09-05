class ExpendituresController < ApplicationController
  # GET /expenditures
  # GET /expenditures.json
  def index
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @report = Report.find(params[:report_id])
    @expenditures = @report.expenditures.all

    respond_to do |format|
      format.html {render :layout => 'fullwidth'} # index.html.erb
      format.json { render json: @expenditures }
    end
  end

  # GET /expenditures/1
  # GET /expenditures/1.json
  def show
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @report = Report.find(params[:report_id])
    @expenditure = Expenditure.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @expenditure }
    end
  end

  # GET /expenditures/new
  # GET /expenditures/new.json
  def new
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @report = Report.find(params[:report_id])
    @expenditure = Expenditure.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @expenditure }
    end
  end

  # GET /expenditures/1/edit
  def edit
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @report = Report.find(params[:report_id])
    @expenditure = Expenditure.find(params[:id])
  end

  # POST /expenditures
  # POST /expenditures.json
  def create
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @report = Report.find(params[:report_id])
    @expenditure = Expenditure.new(params[:expenditure])
    @expenditure.report_id = @report.id
    @expenditure.filer_id = @filer.id

    respond_to do |format|
      if @expenditure.save
        format.html { redirect_to  user_filer_report_expenditures_path(@user, @filer, @report), notice: 'Expenditure was successfully created.' }
        format.json { render json: @expenditure, status: :created, location: @expenditure }
      else
        format.html { render action: "new" }
        format.json { render json: @expenditure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /expenditures/1
  # PUT /expenditures/1.json
  def update
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @report = Report.find(params[:report_id])
    @expenditure = Expenditure.find(params[:id])

    respond_to do |format|
      if @expenditure.update_attributes(params[:expenditure])
        format.html { redirect_to user_filer_report_expenditures_path(@user, @filer, @report), notice: 'Expenditure was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @expenditure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenditures/1
  # DELETE /expenditures/1.json
  def destroy
    @user = current_user
    @filer = Filer.find(params[:filer_id])
    @report = Report.find(params[:report_id])
    @expenditure = Expenditure.find(params[:id])
    @expenditure.destroy unless ! @expenditure.filer.user_id == @user.id

    respond_to do |format|
      format.html { redirect_to user_filer_report_expenditures_path(@user, @filer, @report), notice: 'Expenditure was deleted.' }
      format.json { head :no_content }
    end
  end

  # copy expenditure to a new record
  def clone_expenditure
    @user = current_user
    source = Expenditure.find(params[:id])
    @filer = source.filer
    @report = source.report
    @expenditure = Expenditure.new(source.attributes.slice(*Expenditure.accessible_attributes))
    render :new
  end

end
