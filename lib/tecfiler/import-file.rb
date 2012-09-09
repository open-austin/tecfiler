require "csv"

module TECFiler
  
  # Import TEC data from a CSV file.
  #
  # Example:
  #   
  #    coh =  TECFiler::Model::COH.create( ... )
  #    TECFiler::ImportFile.each(file_contribs, :import_type => :contributions) do |row|
  #      TECFiler::Model::Contribution.create_from_import_row(row, coh)
  #    end
  #    TECFiler::ImportFile.each(file_expends, :import_type => :expenditures) do |row|
  #      TECFiler::Model::Expenditure.create_from_import_row(row, coh)
  #    end
  #
  class ImportFile < CSV
    
    # Acts like CSV.new, with the following options added:
    #
    # * :import_type => Symbol -- Supported values are :contributions and :expenditures.
    #   This option is a shortcut to set appropriate option for the indicated import,
    #   including setting :headers for the field names.
    # * :skip_empty => Boolean -- Skips records where all fields are empty.
    # * :skip_comments => Boolean -- Skip records that begin with "#".
    # * :cleanup_whitespace => Boolean -- Cleanup values by stripping leading/trailing
    #   whitespace, collapsing internal whitespace.
    #
    def initialize(data, options = {})
      
      options1 = case options[:import_type]
      when :contributions
        {
          :headers => TECFiler::Model::Contribution::IMPORT_COLS,
          :skip_blanks => true,
          :skip_empty => true,
          :skip_comments => true,
          :cleanup_whitespace => true,
        }
      when :expenditures
        {
          :headers => TECFiler::Model::Expenditure::IMPORT_COLS,
          :skip_blanks => true,
          :skip_empty => true,
          :skip_comments => true,
          :cleanup_whitespace => true,
        }
      when nil
        {}
      else
        raise "unknown TecFiler::ImportFile type \"#{option[:import_type]}\""
      end.merge(options)
      options1.delete(:import_type)      
      
      @skip_empty = options1.delete(:skip_empty) || false
      @skip_comments = options1.delete(:skip_comments) || false
      @cleanup_whitespace = options1.delete(:cleanup_whitespace) || false
      
      super(data, options1)
    end
    
    
    def cleanup_value(value)
      return nil unless value
      value1 = value.gsub(/\s+/, ' ').strip
      return nil if value1.empty?
      value1
    end
    private :cleanup_value
    
    
    # Wraps arount CSV#shift to implement our added options.
    def shift      
      loop do
      
        row = super
        return nil unless row
        next if row[0] =~ /^#/ && @skip_comments
      
        # when :cleanup_whitespace given, trim leading/trailing ws and collapse internal ws
        if @cleanup_whitespace
          row = case row
          when Array
            row.map {|v| cleanup_value(v)}
          else
            row1 = {}
            row.each {|k, v| row1[k] = cleanup_value(v)}
            row1
          end
        end
        
        # when :skip_empty given, skip rows where all fields are empty
        if @skip_empty
          all_empty = true
          case row
          when Array
            row.each {|v| all_empty = false unless v.empty?}
          else
            row.each {|k, v| all_empty = false unless v.empty?}
          end
          next if all_empty
        end 
        
        return row
        
      end
      # not reached  
    end
    
  end # class CSV 
end # module TECFiler