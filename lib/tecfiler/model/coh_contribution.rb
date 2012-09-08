module TECFiler
  module Model
    
    # Represents a single entry from Form C/OH Schedule A
    # (Political Contributions Other than Pledges or Loans)
    #
    # This model is versioned, and matches the 28-Sept-2011 form.
    #
    class COH_Contribution_20110928

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
      
      property :amount, Decimal, :precision => 10, :scale => 2, :required => true
      property :in_kind_description, String
      
      property :occupation, String, :required => true
      property :employer, String, :required => true
      
    end # class COH_Contribution_20110928
    
    # The current version of the COH_Contribution model.
    COH_Contribution = COH_Contribution_20110928
    
  end # module Model
end # module TECFiler

# vi:et:ai:ts=2:sw=2
