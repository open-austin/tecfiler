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

      # XXX - need to add "C/OH page 2" fields
      
      # Report CO/H schedules and schedule line items
      
      has n, :contributions, "COH_SchedA_Contributions_20110928"

    end # class ReportCOH_20110928
    
    # The current version of the ReportCOH model.
    ReportCOH = ReportCOH_20110928

    
    # TODO: comment
    class COH_SchedA_Contributions_20110928

      include DataMapper::Resource
      
      belongs_to :report_coh, "ReportCOH_20110928"
      
      property :id, Serial
      property :version, String, :required => true, :default => "20110928"
      
      property :date, Date, :required => true
      property :name, String, :required => true
      property :is_out_of_state_pac, Boolean, :default => false
      property :pac_id, String

      # XXX - can/should this information be aggregated into an "Address" property type?
      property :address, String, :required => true
      property :city, String, :required => true
      property :state, String, :required => true
      property :zip, String, :required => true
      
      property :amount, Decimal, :required => true # XXX - check this property
      property :in_kind_description, String
      
      property :occupation, String, :required => true
      property :employer, String, :required => true
      
    end # class COH_SchedA_Contributions_20110928
    
    # The current version of the COH_SchedA_Contributions model.
    COH_SchedA_Contributions = COH_SchedA_Contributions_20110928
    
  end # module Model
end # module TECFiler

# vi:et:ai:ts=2:sw=2
