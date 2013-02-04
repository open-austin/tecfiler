module TECFiler
  class Form
    
    BASEDIR_FORMS = File.dirname(__FILE__) + "/forms"
    
    def initialize(id, options = {})
      @id = id
      case id
      when :COH
        @authority = options[:authority] ||= "state.tx.us"
        @version = options[:version] ||= "20110928"
        @filename = "coh.pdf"
        @produce_report = :produce_report_coh_20110928
      when :SPAC
        @authority = options[:authority] ||= "state.tx.us"
        @version = options[:version] ||= "20110928"
        @filename = "spac.pdf"
        @produce_report = :produce_report_spac_20110928
      else
        raise "unknown form id \"#{id}\""
      end
      @template = "#{BASEDIR_FORMS}/#{@authority}/#{@version}/#{@filename}" 
      raise "source file \"#{@template}\" not found" unless File.exist?(@template)
    end
    
    def produce_report(filing)
      self.send(@produce_report, filing)
    end
    
    def produce_report_coh_20110928(filing)
      raise "sorry, not implemented yet"
    end
    
    def produce_report_spac_20110928(filing)
      raise "sorry, not implemented yet"
    end
    
    
  end
end