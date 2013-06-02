class Report < ActiveRecord::Base

 	belongs_to :filer 
  has_many :contributions
  has_many :expenditures

  has_attached_file :contribution_csv
  validates_attachment :contribution_csv, :content_type => { content_type: "text/csv"}

  has_attached_file :expenditure_csv
  validates_attachment :expenditure_csv, :content_type => { content_type: "text/csv"}

  attr_accessible :contribution_csv, :election_date, :election_type, :expenditure_csv, :office_held, 
    :office_sought, :period_begin, :period_end, :report_type, :status
 
  validates_presence_of :election_type, :if => lambda{|t| ! t.office_sought.empty?}

  validates_presence_of :office_sought, :if => lambda{|t| ! t.election_type.nil?}

  validates_presence_of :filer_id

  def self.types
    { "January 15" => "JAN15", "July 15" => "JUL15", 
      "Election 30 day" => "ELECTION_30DAY", "Election 8 day" => "ELECTION_8DAY", 
      "Runoff" => "RUNNOFF", "Exceed 500" => "EXCEED_500", 
      "Treasurer Appointment" => "TREASURER_APPT", "Final" => "FINAL" } 
  end

  def self.election_types
    { "Primary" => "PRIMARY", "Runoff" => "RUNOFF", 
      "General" => "GENERAL", "Special" => "SPECIAL" } 
  end

end
