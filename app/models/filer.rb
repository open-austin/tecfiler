class Filer < ActiveRecord::Base

 	belongs_to :user 
  has_one :treasurer
  has_many :reports

  attr_accessible :address_city, :address_state, :address_street, :address_suite, 
    :address_zip, :filer_type, :name_first, :name_last, :name_mi, :name_nick, :name_prefix, :name_suffix, :phone

  validates_format_of :phone, :with => /(^$)|(^(\d\d\d-)?\d\d\d-\d\d\d\d(x\d+)?$)/,
    :message => 'Please enter a valid phone number (e.g. "512-555-1234x200")',
    :if => Proc.new { |f| !f.phone.blank? }  

  validates_presence_of :user_id
  validates_presence_of :filer_type
  validates_presence_of :name_first
  validates_presence_of :name_first
  validates_presence_of :name_last
  validates_presence_of :address_street
  validates_presence_of :address_city
  validates_presence_of :address_state
  validates_presence_of :address_zip
  validates_presence_of :phone

  before_save :set_version

  def set_version
    self.version = VERSION
  end

  after_save :update_reports

  def update_reports
    Report.update_filer_info!(self)
  end

  def self.types
    { "COH - Candidate Office Holder" => "COH", 
      "SPAC - Non-Judicial Specific Purpose Committee" => "SPAC",
      "GPAC - General Purpose Committee" => "GPAC" }
  end

  def name
    a = [
      self.name_prefix,
      self.name_first,
      self.name_mi,
      self.name_nick.blank? ? nil : "(#{self.name_nick})",
      self.name_last,
      self.name_suffix,
    ].reject {|x| x.blank?}.join(" ")        
  end
      
  def address
    addr = []
    a = self.address_street
    a << " ste " + self.address_suite unless self.address_suite.nil?
    addr << a
    addr << self.address_city + ", " + self.address_state + " " + self.address_zip
    return addr        
  end

end
