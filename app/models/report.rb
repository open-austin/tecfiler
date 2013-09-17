class Report < ActiveRecord::Base

 	belongs_to :user 
 	belongs_to :filer 
 	belongs_to :treasurer 
  has_many :contributions
  has_many :expenditures

  has_attached_file :contribution_csv
  validates_attachment :contribution_csv, :content_type => { content_type: "text/csv"}

  has_attached_file :expenditure_csv
  validates_attachment :expenditure_csv, :content_type => { content_type: "text/csv"}

  after_create :initialize_filer_treasurer

  attr_accessible :contribution_csv, :election_30_day, :election_8_day, :election_date, 
    :election_type, :exceeded_500_limit, :expenditure_csv, :final, :january_15, :july_15,
    :office_held, :office_sought, :period_begin, :period_end, :report_type, 
    :run_off, :status, :treasurer_appointment

  validates_presence_of :election_type, :if => lambda{|t| ! t.office_sought.empty?}

  validates_presence_of :office_sought, :if => lambda{|t| ! t.election_type.nil?}

  validates_presence_of :filer_id

  validate :report_type_was_checked

  scope :in_progress, :conditions => ["status = ? or status = ?", "new", "in_progress"]
  scope :submitted, :conditions => ["status = ?", "submitted"]
  scope :filed, :conditions => ["status = ?", "filed"]
  scope :error, :conditions => ["status = ?", "error"]

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

  # populate coh and treasurer info when creating new report or updating filer and treasurer
  def initialize_filer_treasurer
    f = self.filer
    if f?
      self.coh_name_prefix = f.name_prefix
      self.coh_name_first = f.name_first
      self.coh_name_mi = f.name_mi
      self.coh_name_nick = f.name_nick
      self.coh_name_last = f.name_last
      self.coh_name_suffix = f.name_suffix
      self.coh_address_street = f.address_street
      self.coh_address_suite = f.address_suite
      self.coh_address_city = f.address_city
      self.coh_address_state = f.address_state
      self.coh_address_zip = f.address_zip
      self.coh_phone = f.phone
    end

    t = self.treasurer
    if t?
      self.treasurer_name_prefix = t.name_prefix
      self.treasurer_name_first = t.name_first
      self.treasurer_name_mi = t.name_mi
      self.treasurer_name_nick = t.name_nick
      self.treasurer_name_last = t.name_last
      self.treasurer_name_suffix = t.name_suffix
      self.treasurer_address_street = t.address_street
      self.treasurer_address_suite = t.address_suite
      self.treasurer_address_city = t.address_city
      self.treasurer_address_state = t.address_state
      self.treasurer_address_zip = t.address_zip
      self.treasurer_phone = t.phone
    end

    self.save!
  end

  def self.update_filer_treasurer(filer)
    Report.where("filer_id = ? and status <> ?", filer.id, "filed").each do |report|
      report.initialize_filer_treasurer
    end
  end
 
  private

  def report_type_was_checked
    if self.january_15.blank? and self.july_15.blank? and self.election_30_day.blank? and
      self.election_8_day.blank? and self.run_off.blank? and self.exceeded_500_limit.blank? and
      self.treasurer_appointment.blank? and self.final.blank?
        self.errors.add(:report_type, "must have at least one option selected")
    end
  end

end
