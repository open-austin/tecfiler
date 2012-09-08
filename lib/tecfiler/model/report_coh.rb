module TECFiler
  module Model

    # Represents a "Candidate/Office Holder Campaign Finance Report" (Form C/OH)
    #
    # This model is versioned, and matched the 28-Sept-2011 form.
    #
    # The source for this form is: http://www.ethics.state.tx.us/forms/coh.pdf
    #
    # For more information see: http://www.ethics.state.tx.us/filinginfo/localcohfrm.htm
    #
    class ReportCOH_20110928
      
      include DataMapper::Resource

      property :id, Serial
      property :version, String, :required => true, :default => "20110928"

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

      # XXX - should these be Boolean or Enum?
      property :report_type_jan15, Boolean, :default => false
      property :report_type_jul15, Boolean, :default => false
      property :report_type_30_day, Boolean, :default => false
      property :report_type_8_day, Boolean, :default => false
      property :report_type_runoff, Boolean, :default => false
      property :report_type_exceed_500, Boolean, :default => false
      property :report_type_treasurer_appt, Boolean, :default => false
      property :report_type_final, Boolean, :default => false

      property :period_begin, Date, :required => true
      property :period_end, Date, :required => true

      property :election_date, Date

      # XXX - Should these (except "runoff") be an enum?
      property :election_type_primary, Boolean, :default => false
      property :election_type_runoff, Boolean, :default => false
      property :election_type_general, Boolean, :default => false
      property :election_type_special, Boolean, :default => false

      property :office_held, String
      property :office_sought, String

      # TODO - need to add "C/OH page 2" fields

      # Schedule A: Political Contributions other than Pledges or Loans
      
      has n, :contributions, "COH_Contribution_20110928"
        
      # Schedule B: Pledged Contributions (TODO)
      
      # Schedule E: Loans (TODO)
      
      # Schedule F: Political Expenditures (TODO)
      
      # Schedule G: Political Expenditures Made from Personal Funds (TODO)
      
      # Schedule H: Payment from Political Contributions to a Business of C/OH (TODO)
      
      # Schedule I: Non-Political Expenditures made from Political Contributions
      
      # Schedule K: Interest Earned, Other Credits/Gains/Refunds, and Purchase of Investments (TODO)
      
      # Schedule T: In-Kind Contribution or Political Expenditure for Travel Outside of Texas (TODO)
      

    end # class ReportCOH_20110928
    
    # The current version of the ReportCOH model.
    ReportCOH = ReportCOH_20110928

  end # module Model
end # module TECFiler

# vi:et:ai:ts=2:sw=2
