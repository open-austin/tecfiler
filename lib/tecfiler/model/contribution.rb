module TECFiler
  module Model
    

    # TODO - document
    class Contribution

      # According to the import guide, code "R" items are marked as required
      # but TEC will accept form without them. The CODE_R parameter may be used
      # to determine whether we should reject (CODE_R true) or accept (CODE_R false)
      # filings without these values.
      #
      # XXX - might be a nice feature to generate warnings (not errors) when
      # CODE_R is false.
      #
      CODE_R = true

      include DataMapper::Resource
      
      belongs_to :coh, "COH", :required => false
      belongs_to :spac, "SPAC", :required => false    
      validates_with_method :check_association, :when => [:default]
      
      def check_association #:nodoc:
        n = 0
        n += 1 if self.coh
        n += 1 if self.spac
        case n
        when 0
          [false, "contribution not associated with any reports"]
        when 1
          true          
        else
          [false, "contribution is associated with more than one report"]
        end
      end
      private :check_association
      
      property :id, Serial
      property :version, String, :required => true, :default => "20110928"
      
      property :rec_type, Enum[:RECEIPT, :PLEDGE], :required => true
        
      def rec_type=(value) #:nodoc:
        case value
        when /^r/i
          super(:RECEIPT)
        when /^p/i
          super(:PLEDGE)
        else
          super(value)
        end
      end
      
      # Mapping to identify which form types are valid for a given report.
      #
      # Example:
      #
      #   FORM_TYPES[:LOCAL_NONJUDICIAL_COH].include?(:A1) ->  true
      #
      FORM_TYPES = {
        :LOCAL_NONJUDICIAL_COH => [:A1, :B1],
        :LOCAL_NONJUDICIAL_SPAC => [:A1, :B1, :C],
      }
        
      property :form_type, Enum[:A1, :A2, :AJ, :AL, :B1, :B2, :B3, :BJ, :C, :C2, :D], :required => true
        validates_within :form_type,
          :set => FORM_TYPES[:LOCAL_NONJUDICIAL_COH] + FORM_TYPES[:LOCAL_NONJUDICIAL_SPAC],
          :message => "form type is not appropriate for local, non-judicial offices"
              
      property :contributor_type, Enum[:INDIVIDUAL, :ENTITY], :required => true
        validates_within :contributor_type, :set => [:ENTITY],
          :message => "Only \"ENTITY\" type contributors can be entered for this form type.",
          :if => lambda{|t| [:C, :C2, :D].include?(t.form_type)}
      
      def contributor_type=(value)  #:nodoc:
        case value
        when /^i/i
          super(:INDIVIDUAL)
        when /^e/i
          super(:ENTITY)
        else
          super(value)
        end
      end
      
      property :name_title, String, :length => 25        # e.g. "Mr."
        validates_absence_of :name_title, :if  => lambda{|t| t.contributor_type == :ENTITY}
      property :name_first, String, :length => 45
        validates_presence_of :name_first, :if => lambda{|t| t.contributor_type == :INDIVIDUAL}
      property :name_last, String, :length => 100, :required => true
      property :name_suffix, String, :length => 10       # e.g. "Jr."
        validates_absence_of :name_suffix, :if  => lambda{|t| t.contributor_type == :ENTITY}
       
      property :address, String, :length => 55, :required => CODE_R
      property :address2, String, :length => 55
      property :city, String, :length => 30, :required => CODE_R
      property :state, String, :length => 2, :required => CODE_R, :format => :state_code
      property :zip, String, :length => 10, :required => CODE_R, :format => :zip_code
      
      property :is_out_of_state_pac, Boolean
        validates_absence_of :is_out_of_state_pac, :if  => lambda{|t| [:AL, :C].include?(t.form_type)} 
      property :pac_id, String, :length => 9
        validates_presence_of :pac_id, :if => lambda{|t| t.is_out_of_state_pac}   
        validates_absence_of :pac_id, :if  => lambda{|t| [:AL, :C].include?(t.form_type)} 

        
      property :date, Date, :required => true
      property :amount, Decimal, :precision => 12, :scale => 2, :required => true
      property :in_kind_description, String, :length => 100
      property :employer, String, :length => 60
        validates_presence_of :employer, :if => lambda{|t| [:AJ].include?(t.form_type)}  
        validates_absence_of :employer, :if => lambda{|t| [:AL, :C].include?(t.form_type)} 
      property :occupation, String, :length => 60
        validates_presence_of :occupation, :if => lambda{|t| [:A2, :AJ].include?(t.form_type)}  
        validates_absence_of :occupation, :if => lambda{|t| [:AL, :C].include?(t.form_type)}  
        
      # fields not implemented (applies only to form_type :AJ)
      # * job_title
      # * spous_emp
      # * parent1
      # * parent2
  
      # Import file columns defined by the TEC, in order.
      IMPORT_COLS = [
        :REC_TYPE,
        :FORM_TYPE,
        :ITEM_ID,
        :ENTITY_CD,
        :CTRIB_NAML,
        :CTRIB_NAMF,
        :CTRIB_NAMT,
        :CTRIB_NAMS,
        :CTRIB_ADR1,
        :CTRIB_ADR2,
        :CTRIB_CITY,
        :CTRIB_STCD,
        :CTRIB_ZIP4,
        :OS_PAC_CB,
        :OS_PAC_FEC,
        :CTRIB_DATE,
        :CTRIB_AMT,
        :CTRIB_DSCR,
        :EMPLOYER,
        :OCCUP,
        :JOB_TITLE,
        :SPOUS_EMP,
        :PARENT1,
        :PARENT2,      
      ]
      
      
      # Construct a hash of parameters to create a new Contribution instance
      # from an import table row.
      def self.params_from_import_row(row, owner = nil)        
        {
          :rec_type => row[:REC_TYPE],
          :form_type => row[:FORM_TYPE],
          :contributor_type => row[:ENTITY_CD],
          :name_title => row[:CTRIB_NAMT],
          :name_first => row[:CTRIB_NAMF],
          :name_last => row[:CTRIB_NAML],
          :name_suffix => row[:CTRIB_NAMS],    
          :address => row[:CTRIB_ADR1],
          :address2 => row[:CTRIB_ADR2],
          :city => row[:CTRIB_CITY],
          :state => row[:CTRIB_STCD],
          :zip => row[:CTRIB_ZIP4],
          :is_out_of_state_pac => row[:OS_PAC_CB],
          :pac_id => row[:OS_PAC_FEC],      
          :date => row[:CTRIB_DATE],
          :amount => row[:CTRIB_AMT],
          :in_kind_description => row[:CTRIB_DSCR],
          :employer => row[:EMPLOYER],
          :occupation => row[:OCCUP],
          :coh => owner,
        }
      end
      
      # Validate a Contribution import table row.
      # Returns nil if row validates without problem.
      # If validation problems were encountered, returns a DataMapper::Validations::ValidationErrors.
      def self.validate_import_row(row, scope = :default)
        contribution = new(params_from_import_row(row))
        contribution.valid?(scope) ? nil : contribution.errors
      end
      
      # Create a new Contribution database record from an import table row.
      # Follows the semantics of create(): Always returns a Contribution instance,
      # you'll need to check saved?() to verify whether save was successful.
      def self.create_from_import_row(row, coh)
        create(params_from_import_row(row, coh))
      end
      
    end # class Contribution    
  end # module Model
end # module TECFiler

# vi:et:ai:ts=2:sw=2