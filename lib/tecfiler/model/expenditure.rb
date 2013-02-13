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
            
      property :item_id, String, :length => 20
              
      property :payee_type, Enum[:INDIVIDUAL, :ENTITY], :required => true
        validates_within :payee_type, :set => [:ENTITY],
          :message => "Only \"ENTITY\" type contributors can be entered for this form type.",
          :if => lambda{|t| [:C, :C2, :D].include?(t.form_type)}
      
      def payee_type=(value)
        case value
        when /^i/i
          super(:INDIVIDUAL)
        when /^e/i
          super(:ENTITY)
        else
          super(value)
        end
      end
      
      property :payee_name_title, String, :length => 15        # e.g. "Mr."
        validates_absence_of :name_title, :if  => lambda{|t| t.payee_type == :ENTITY}
      property :payee_name_first, String, :length => 45
        validates_presence_of :name_first, :if => lambda{|t| t.payee_type == :INDIVIDUAL}
      property :payee_name_last, String, :length => 100, :required => true
      property :payee_name_suffix, String, :length => 10       # e.g. "Jr."
        validates_absence_of :name_suffix, :if  => lambda{|t| t.payee_type == :ENTITY}
       
      property :payee_address, String, :length => 55, :required => @require_code_r_items
      property :payee_address2, String, :length => 55
      property :payee_city, String, :length => 30, :required => @require_code_r_items
      property :payee_state, String, :length => 2, :required => @require_code_r_items, :format => :state_code
      property :payee_zip, String, :length => 10, :required => @require_code_r_items, :format => :zip_code
        
      property :date, Date, :required => true
      property :amount, Decimal, :precision => 12, :scale => 2, :required => true
      property :description, String, :length => 100, :required => @require_code_r_items
        
      # XXX - skipping field   ExpCntr_YN (Expenditure is a contribution?)
      # only applies to Sched UC-EXP of COH-UC reports
      
      property :reimbursement_expected, Boolean
        validates_absence_of :reimbursement_expected, :if  => lambda{|t| ! [:G].include?(t.form_type)} 
      
      property :candidate_name_title, String, :length => 15        # e.g. "Mr."
      property :candidate_name_first, String, :length => 45
      property :candidate_name_last, String, :length => 100
      property :candidate_name_suffix, String, :length => 10       # e.g. "Jr."
       
      property :office_held_code, Enum[:GOV, :LGV, :AG, :COM, :LC, :AC, :RC, :SCJ, :CAJ, :SEN, :REP, :COA, :DJ, :DA, :SBE, :OTH]
      property :office_held_description, String, :length => 30
        validates_presence_of :office_held_description, :if  => lambda{|t| t.office_held_code == :OTH}
      property :office_held_district, String, :length => 4
      
      property :office_sought_code, Enum[:GOV, :LGV, :AG, :COM, :LC, :AC, :RC, :SCJ, :CAJ, :SEN, :REP, :COA, :DJ, :DA, :SBE, :OTH]
      property :office_sought_description, String, :length => 30
        validates_presence_of :office_sought_description, :if  => lambda{|t| t.office_sought_code == :OTH}
      property :office_sought_district, String, :length => 4
                         
      property :backreference_id, String, :length => 20
      
      property :is_corp_contrib, Boolean      
  
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
          :item_id => row[:ITEM_ID],
          :payee_type => row[:ENTITY_CD],
          :payee_name_last => row[:PAYEE_NAML],
          :payee_name_first => row[:PAYEE_NAMF],
          :payee_name_title => row[:PAYEE_NAMT],
          :payee_name_suffix => row[:PAYEE_NAMS],
          :payee_address => row[:PAYEE_ADR1],
          :payee_address2 => row[:PAYEE_ADR2],
          :payee_city => row[:PAYEE_CITY],
          :payee_state => row[:PAYEE_STCD],
          :payee_zip => row[:PAYEE_ZIP4],
          :date => row[:EXPN_DATE],
          :amount => row[:EXPN_AMT],
          :description => row[:EXPN_DESCR],
          # skipping row[:EXPCNTR_YN] -- XXX check this
          :reimbursement_expected => row[:REIMBUR_CB],
          :candidate_name_last => row[:CAND_NAML],
          :candidate_name_first => row[:CAND_NAMF],
          :candidate_name_title => row[:CAND_NAMT],
          :candidate_name_suffix => row[:CAND_NAMS],
          :office_held_code => row[:OFFHLDCD],
          :office_held_description => row[:OFFHLDNAM],
          :office_held_district => row[:OFFHLDNUM],
          :office_sought_code => row[:OFFSEEKCD],
          :office_sought_description => row[:OFFSEEKNAM],
          :office_sought_district => row[:OFFSEEKNUM],
          :backreference_id => row[:BAKREF_ID],
          :is_corp_contrib => row[:EXPNCORP_YN],
          :coh => owner,
        }
      end
      
      # Validate a Expenditure import table row.
      # Returns nil if row validates without problem.
      # If validation problems were encountered, returns a DataMapper::Validations::ValidationErrors.
      def self.validate_import_row(row)
        expenditure = new(params_from_import_row(row).merge(:unassociated => true))
        expenditure.valid? ? nil : expenditure.errors
      end
      
      # Create a new Expenditure database record from an import table row.
      # Follows the semantics of create(): Always returns a Expenditure instance,
      # you'll need to check saved?() to verify whether save was successful.
      def self.create_from_import_row(row, params = {})
        create(params_from_import_row(row).merge(params))
      end
    
    end # class Expenditure  
    
  end # module Model
end # module TECFiler

# vi:et:ai:ts=2:sw=2