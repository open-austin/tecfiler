module TECFiler
  module Model    

    # TODO - document
    class Expenditure

      VERSION = "20110928"

      # According to the import guide, code "R" items are marked as required
      # but TEC will accept form without them. This class instance parameter
      # controls whether we should reject (@require_code_r_items true)
      # or accept (@require_code_r_items false) filings without these values.
      #
      @require_code_r_items = true

      include DataMapper::Resource
      
      # Do not use @unassociated in normal operation.
      #
      # When testing, you can set @unassociated true to test this instance
      # without associating it with a COH or SPAC entity. If you make a
      # COH or SPAC assignment then this parameter will be set false, thus
      # enabling validation of the association.
      #
      attr_accessor :unassociated
      
      belongs_to :coh, "COH", :required => false
      def coh=(value) #:nodoc:
        @unassociated = false
        super(value)
      end
      
      belongs_to :spac, "SPAC", :required => false    
      def spac=(value) #:nodoc:
        @unassociated = false
        super(value)
      end
        
      validates_with_method :check_association
      
      def check_association #:nodoc:
        return true if @unassociated
        n = 0
        n += 1 if self.coh
        n += 1 if self.spac
        case n
        when 0
          [false, "expenditure not associated with any reports"]
        when 1
          true          
        else
          [false, "expenditure is associated with more than one report"]
        end
      end
      private :check_association
      

      property :id, Serial
      property :version, String, :required => true, :default => VERSION
      
      property :rec_type, Enum[:EXPENDITURE], :required => true
        
      def rec_type=(value)
        case value
        when /^e/i
          super(:EXPENDITURE)
        else
          super(value)
        end
      end
      
      FORM_TYPES = {
        :LOCAL_NONJUDICIAL_COH => [:F, :G, :H, :I],
        :LOCAL_NONJUDICIAL_SPAC => [:F, :H, :I],
      }
        
      property :form_type, Enum[:F, :FL, :G, :H, :I], :required => true
        validates_within :form_type,
          :set => FORM_TYPES[:LOCAL_NONJUDICIAL_COH] + FORM_TYPES[:LOCAL_NONJUDICIAL_SPAC],
          :message => "form type is not appropriate for local, non-judicial offices"
              
      property :recipient_type, Enum[:INDIVIDUAL, :ENTITY], :required => true
        validates_within :recipient_type, :set => [:ENTITY],
          :message => "Only \"ENTITY\" type contributors can be entered for this form type.",
          :if => lambda{|t| [:C, :C2, :D].include?(t.form_type)}
      
      def recipient_type=(value)
        case value
        when /^i/i
          super(:INDIVIDUAL)
        when /^e/i
          super(:ENTITY)
        else
          super(value)
        end
      end
      
      property :name_title, String, :length => 15        # e.g. "Mr."
        validates_absence_of :name_title, :if  => lambda{|t| t.recipient_type == :ENTITY}
      property :name_first, String, :length => 45
        validates_presence_of :name_first, :if => lambda{|t| t.recipient_type == :INDIVIDUAL}
      property :name_last, String, :length => 100, :required => true
      property :name_suffix, String, :length => 10       # e.g. "Jr."
        validates_absence_of :name_suffix, :if  => lambda{|t| t.recipient_type == :ENTITY}
       
      property :address, String, :length => 55, :required => @require_code_r_items
      property :address2, String, :length => 55
      property :city, String, :length => 30, :required => @require_code_r_items
      property :state, String, :length => 2, :required => @require_code_r_items, :format => :state_code
      property :zip, String, :length => 10, :required => @require_code_r_items, :format => :zip_code
        
      property :date, Date, :required => true
      property :amount, Decimal, :precision => 12, :scale => 2, :required => true
      property :description, String, :length => 100, :required => @require_code_r_items
        
      # XXX - skipping field   ExpCntr_YN (Expenditure is a contribution?)
      # only applies to Sched UC-EXP of COH-UC reports
      
      property :reimbursement_expected, Boolean
        validates_absence_of :reimbursement_expected, :if  => lambda{|t| ! [:G].include?(t.form_type)} 

      # TODO - fields 19 - 28 (to another C/OH under certain circumstances)
      # TODO - BakRef_ID (field 29, for child records)
          
      # fields not implemented (applies only to GPAC/MPAC filings)
      # * ExpnCorp_YN (field 30)
  
      IMPORT_COLS = [
        :REC_TYPE,
        :FORM_TYPE,
        :ITEM_ID,
        :ENTITY_CD,
        :PAYEE_NAML,
        :PAYEE_NAMF,
        :PAYEE_NAMT,
        :PAYEE_NAMS,
        :PAYEE_ADR1,
        :PAYEE_ADR2,
        :PAYEE_CITY,
        :PAYEE_STCD,
        :PAYEE_ZIP4,
        :EXPN_DATE,
        :EXPN_AMT,
        :EXPN_DESCR,
        :EXPCNTR_YN,
        :REIMBUR_CB,
        :CAND_NAML,
        :CAND_NAMF,
        :CAND_NAMT,
        :CAND_NAMS,
        :OFFHLDCD,
        :OFFHLDNAM,
        :OFFHLDNUM,
        :OFFSEEKCD,
        :OFFSEEKNAM,
        :OFFSEEKNUM,
        :BAKREF_ID,
        :EXPNCORP_YN,
      ]
      
    
    # Parameters to create a new Expenditure instance from an import table row.
    def self.params_from_import_row(row, owner = nil)
      {
        :rec_type => row[:REC_TYPE],
        :form_type => row[:FORM_TYPE],
        :recipient_type => row[:ENTITY_CD],
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
    
    # Validate a Expenditure import table row.
    # Returns nil if row validates without problem.
    # If validation problems were encountered, returns a DataMapper::Validations::ValidationErrors.
    def self.validate_import_row(row, scope = :default)
      expenditure = new(params_from_import_row(row))
      expenditure.valid?(scope) ? nil : expenditure.errors
    end
    
    # Create a new Expenditure database record from an import table row.
    # Follows the semantics of create(): Always returns a Expenditure instance,
    # you'll need to check saved?() to verify whether save was successful.
    def self.create_from_import_row(row, coh)
      create(params_from_import_row(row, coh))
    end
    
    end # class Expenditure  
    
  end # module Model
end # module TECFiler

# vi:et:ai:ts=2:sw=2