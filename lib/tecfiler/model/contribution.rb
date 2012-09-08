module TECFiler
  module Model
    
    # Represents a single entry from Form C/OH Schedule A
    # (Political Contributions Other than Pledges or Loans)
    #
    # This model is versioned, and matches the 28-Sept-2011 form.
    #
    class Contribution_20110928

      # According to the import guide, code "R" items are marked as required,
      # but TEC will accept form without them. This configuration setting is set
      # to indicate whether we should reject the form if unspecified.
      #
      # XXX - nice feature would be to kick out warning when CODE_R is false
      # (i.e. accept empty fields)
      #
      CODE_R = true

      include DataMapper::Resource
      
      # FIXME - this can belong to different report entitites, not just C/OH
      #belongs_to :report_coh, "ReportCOH_20110928"
      
      property :id, Serial
      property :version, String, :required => true, :default => "20110928"
      
      property :rec_type, Enum[:RECEIPT, :PLEDGE], :required => true
        
      def rec_type=(value)
        case value
        when /^r/i
          super(:RECEIPT)
        when /^p/i
          super(:PLEDGE)
        else
          super(value)
        end
      end
        
      property :form_type, Enum[:A1, :A2, :AJ, :AL, :C, :C2, :B1, :B2, :B3, :BJ, :D], :required => true
            
      property :entity_code, Enum[:INDIVIDUAL, :ENTITY], :required => true
      
      def entity_code=(value)
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
      property :name_first, String, :length => 45
        validates_presence_of :name_first, :if => lambda{|t| t.entity_code == :INDIVIDUAL}
      property :name_last, String, :length => 100, :required => true
      property :name_suffix, String, :length => 10       # e.g. "Jr."
       
      property :address, String, :length => 55, :required => CODE_R
      property :address2, String, :length => 55
      property :city, String, :length => 30, :required => CODE_R
      property :state, String, :length => 2, :required => CODE_R, :format => :state_code
      property :zip, String, :length => 10, :required => CODE_R, :format => :zip_code
      
      property :is_out_of_state_pac, Boolean, :default => false
      property :pac_id, String, :length => 9
        validates_presence_of :pac_id, :if => lambda{|t| t.is_out_of_state_pac}      
        
      property :date, Date, :required => true
      property :amount, Decimal, :precision => 12, :scale => 2, :required => true
      property :in_kind_description, String, :length => 100
      property :employer, String, :length => 60
        validates_presence_of :employer, :if => lambda{|t| t.form_type == :AJ}  
      property :occupation, String, :length => 60
        validates_presence_of :occupation, :if => lambda{|t| [:A2, :AJ].include?(t.form_type)}  
        
      # fields not implemented (applies only to form_type :AJ)
      # job_title
      # spous_emp
      # parent1
      # parent2
  
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
      
      def self.from_import_row(row, options = {})
        row_empty = true
        row.each do |key, value|
          if value
            value = value.gsub(/\s+/, " ").strip
            row[key] = value
            row_empty = false unless value.empty?
          end
        end
        if row[0] =~ /^#/ || row_empty
          return nil if options[:skip_empty]
          raise "row is empty"
        end     
        
        new({
          :rec_type => row[:REC_TYPE],
          :form_type => row[:FORM_TYPE],
          :entity_code => row[:ENTITY_CD],
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
        })
      end
      
    end # class Contribution_20110928
    
    # The current version of the Contribution model.
    Contribution = Contribution_20110928
    
  end # module Model
end # module TECFiler

# vi:et:ai:ts=2:sw=2