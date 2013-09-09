ActiveAdmin.register Report do

  menu :priority => 1

  actions :all, :except => [:destroy, :new, :edit]

  action_item only: [:show] do
    if report.state == 'submitted'
      link_to "Approve", approve_admin_report_path(report), :method => :put, :confirm => "Confirm: Are you ready to approve this report?"
    end
  end

  action_item only: [:show] do
    if report.state == 'submitted'
      link_to "Deny", reject_admin_report_path(report), :method => :put, :confirm => "Confirm: Do you want to reject this report?"
    end
  end

  scope :all, :default => true
  scope :submitted do |reports|
    reports.where('state = ?', 'submitted')
  end
  scope :filed do |reports|
    reports.where('state = ?', 'filed')
  end
  scope :error do |reports|
    reports.where('state = ?', 'error')
  end
  scope :in_progress do |reports|
    reports.where('state = ? or state = ?', 'new', 'in_progress')
  end

  index do
    selectable_column
    column :id
    column "Filer" do |report|
      report.filer.name
    end

    column "Status" do |report|
      case report.state
      when 'new'
        report_title = 'New'
        report_status = :warning
      when 'in_progress'
        report_title = 'In Progress'
        report_status = :warning
      when 'submitted'
        report_title = 'Submitted'
        report_status = :error
      when 'filed'
        report_title = 'Filed'
        report_status = :ok
      when 'error'
        report_title = 'Error'
        report_status = :error
      end
      status_tag(report_title, report_status)
    end
    column :period_begin
    column :period_end
    column :election_date
    actions
  end

  filter :filer
  filter :state, :as => :select, :collection => ['submitted', 'in_progress'], :label => 'Status'
  filter :period_begin
  filter :period_end
  filter :election_date
 

  show do
    case report.state
    when 'new'
      report_title = 'New'
      report_status = :warning
    when 'in_progress'
      report_title = 'In Progress'
      report_status = :warning
    when 'submitted'
      report_title = 'Submitted'
      report_status = :error
    when 'filed'
      report_title = 'Filed'
      report_status = :ok
    when 'error'
      report_title = 'Error'
      report_status = :error
    end
    panel "Report Details" do
      attributes_table_for report do
        row("Status") { status_tag(report_title, report_status) }
        row("Filer") { link_to report.filer.name, admin_filer_path(report.filer) }
        row("Candidate Office Holder") { report.coh_name }
        row("Treasurer") { report.treasurer_name }
        row("Period begin") { report.period_begin }
        row("Period end") { report.period_end }
        row("Election date") { report.election_date }
        row("Office sought") { report.office_sought }
        row("Report") { "Placeholder for link to submitted pdf report" }
      end
    end
    active_admin_comments
  end

  member_action :approve, :method => :put do
    report = Report.find(params[:id])
    report.accepted
    redirect_to admin_report_path(report), notice: "The report has been approved."
  end

  member_action :reject, :method => :put do
    report = Report.find(params[:id])
    report.denied
    redirect_to admin_report_path(report), notice: "The report has been rejected."
  end

end
