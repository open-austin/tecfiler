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

  scope :in_progress, :conditions => ["state = ? or state = ?", "new", "in_progress"]
  scope :submitted, :conditions => ["state = ?", "submitted"]
  scope :filed, :conditions => ["state = ?", "filed"]
  scope :error, :conditions => ["state = ?", "error"]

  state_machine :initial => :new do
    event :data_changed do
      transition :new => :in_progress, :error => :in_progress
    end

    event :submitted do
      transition :in_progress => :submitted
    end

    event :accepted do
      transition :submitted => :filed
    end

    event :denied do
      transition :submitted => :error
    end

    state :new, :in_progress, :error do
      def modifiable?
        true
      end
    end

    state :new, :error, :filed, :denied do
      def submittable?
        false
      end
    end

    state :in_progress do
      def submittable?
        true
      end
    end

    state :submitted, :filed do
      def modifiable?
        false
      end
    end
  end

  def self.types
    { "January 15" => "JAN15", "July 15" => "JUL15", 
      "Election 30 day" => "ELECTION_30DAY", "Election 8 day" => "ELECTION_8DAY", 
      "Runoff" => "RUNNOFF", "Exceed 500" => "EXCEED_500", 
      "Treasurer Appointment" => "TREASURER_APPT", "Final" => "FINAL" } 
  end

  def self.election_types
    { "Primary" => "PRIMARY", "Runoff" => "RUNOFF", 
      "General" => "GENERAL", "Special" => "SPECIAL",
      "Other" => "OTHER"} 
  end

  def coh_name
    a = [
      self.coh_name_prefix,
      self.coh_name_first,
      self.coh_name_mi,
      self.coh_name_nick.blank? ? nil : "(#{self.coh_name_nick})",
      self.coh_name_last,
      self.coh_name_suffix,
    ].reject {|x| x.blank?}.join(" ")        
  end
 
  def treasurer_name
    a = [
      self.treasurer_name_prefix,
      self.treasurer_name_first,
      self.treasurer_name_mi,
      self.treasurer_name_nick.blank? ? nil : "(#{self.treasurer_name_nick})",
      self.treasurer_name_last,
      self.treasurer_name_suffix,
    ].reject {|x| x.blank?}.join(" ")        
  end
 
end
