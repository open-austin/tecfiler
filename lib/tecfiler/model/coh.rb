module TECFiler
  module Model

    # Represents a "Candidate/Office Holder Campaign Finance Report" (Form C/OH)
    #
    # The source for this form is: http://www.ethics.state.tx.us/forms/coh.pdf
    #
    # For more information see: http://www.ethics.state.tx.us/filinginfo/localcohfrm.htm
    #
    class COH
      
      VERSION = "20110928"
      
      include DataMapper::Resource

      property :id, Serial
      property :version, String, :required => true, :default => VERSION

      # XXX - can/should this information be aggregated into a "Name" property type?
      property :coh_name_prefix, String
      property :coh_name_first, String, :required => true
      property :coh_name_mi, String
      property :coh_name_nick, String
      property :coh_name_last, String, :required => true
      property :coh_name_suffix, String

      # XXX - can/should this information be aggregated into an "Address" property type?
      property :coh_address_street, String, :required => true
      property :coh_address_suite, String
      property :coh_address_city, String, :required => true
      property :coh_address_state, String, :required => true
      property :coh_address_zip, String, :required => true
      property :coh_address_changed, Boolean, :default => false

      property :coh_phone, String, :required => true, :format => :telno
      
      # XXX - can/should this information be aggregated into a "Name" property type?
      property :treasurer_name_prefix, String
      property :treasurer_name_first, String, :required => true
      property :treasurer_name_mi, String
      property :treasurer_name_nick, String
      property :treasurer_name_last, String, :required => true
      property :treasurer_name_suffix, String

      # XXX - can/should this information be aggregated into an "Address" property type?
      property :treasurer_address_street, String, :required => true
      property :treasurer_address_suite, String
      property :treasurer_address_city, String, :required => true
      property :treasurer_address_state, String, :required => true
      property :treasurer_address_zip, String, :required => true
      property :treasurer_address_changed, Boolean, :default => false

      property :treasurer_phone, String, :required => true, :format => :telno

      property :report_type, Enum[:JAN15, :JUL15, :ELECTION_30DAY, :ELECTION_8DAY, :RUNNOFF, :EXCEED_500, :TREASURER_APPT, :FINAL], :required => true
      
      property :period_begin, Date, :required => true
      property :period_end, Date, :required => true

      property :election_date, Date
      
      # XXX - Should :RUNOFF be an election type or a modifier to the election type?
      property :election_type, Enum[:PRIMARY, :RUNOFF, :GENERAL, :SPECIAL]
        validates_presence_of :election_type, :if => lambda{|t| ! t.office_sought.empty?}

      property :office_held, String
      property :office_sought, String
        validates_presence_of :office_sought, :if => lambda{|t| ! t.election_type.nil?}

      # TODO - need to add "C/OH page 2" fields
      
      has n, :contributions
      has n, :expenditures
      
      def coh_address
        addr = []
        a = self.coh_address_street
        a << " ste " + self.coh_address_suite unless self.coh_address_suite.nil?
        addr << a
        addr << self.coh_address_city + ", " + self.coh_address_state + " " + self.coh_address_zip
        return addr        
      end

    end # class COH
    
  end # module Model
end # module TECFiler

# vi:et:ai:ts=2:sw=2
