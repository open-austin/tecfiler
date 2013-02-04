require "prawn"
require "tempfile"

module TECFiler
  class FormGenerator
    
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
    
    def produce_report(entity)
      self.send(@produce_report, entity)
    end
    
    
    def produce_report_coh_20110928(entity)
      raise "data entity is not a COH" unless entity.instance_of?(TECFiler::Model::COH)
      raise "form version mismatch (expected #{@version}, got #{entity.version})" unless entity.version == @version
      
      #require "pp" ; pp entity, entity.contributions, entity.expenditures
      
      fn = "/tmp/tec-form-xxxxxx.pdf"
      
      Prawn::Document.generate(fn) do |pdf|
        pdf.start_new_page :template => @template, :template_page => 1     
        pdf.text_box "Hello world", :at => [100, 100] 
      end
      
      return fn
    end
    
    def produce_report_spac_20110928(entity)
      raise "sorry, not implemented yet"
    end
    
    
  end
end