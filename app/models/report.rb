class Report < ActiveRecord::Base

 	belongs_to :filer 
  # has_many :contributions
  # has_many :expenditures

  has_attached_file :contribution_csv
  validates_attachment :contribution_csv, :content_type => { content_type: "text/csv"}

  has_attached_file :expenditure_csv
  validates_attachment :expenditure_csv, :content_type => { content_type: "text/csv"}

  attr_accessible :contribution_csv, :election_date, :election_type, :expenditure_csv, :office_held, 
    :office_sought, :period_begin, :period_end, :report_type, :status
 
  validates_presence_of :election_type, :if => lambda{|t| ! t.office_sought.empty?}

  validates_presence_of :office_sought, :if => lambda{|t| ! t.election_type.nil?}

  validates_presence_of :filer_id


end
