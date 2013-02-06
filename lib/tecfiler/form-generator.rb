require "prawn"
require "tempfile"

module TECFiler
  class FormGenerator
    
    BASEDIR_FORMS = File.dirname(__FILE__) + "/forms"
    
    def self.produce(entity, options = {})
      
      @entity = entity
      @authority = options[:authority] || "state.tx.us"
      
      case entity
      when TECFiler::Model::COH
        @id = :COH
        @version = options[:version] || entity.version
        @filename = "coh.pdf"
        @produce = "produce_coh_#{@version}".to_sym
      when TECFiler::Model::SPAC
        @id = :SPAC
        @version = options[:version] || entity.version
        @filename = "spac.pdf"
        @produce = ":produce_spac_#{@version}".to_sym
      else
        raise "do not know how to produce form for entity type #{entity.class}"
      end      
 
      @template = "#{BASEDIR_FORMS}/#{@authority}/#{@version}/#{@filename}"
      raise "form template not found: #{@template}" unless File.exist?(@template)
      
      self.send(@produce)
    end
    
    
    def self.produce_coh_20110928
      
      #require "pp" ; pp @entity, @entity.contributions, @entity.expenditures
      
      fn = "/tmp/tec-form-xxxxxx.pdf"
      
      Prawn::Document.generate(fn) do |pdf|
        #pdf.font_size 20
        
        def pdf.t(value, options)
          return if value.empty? 
          self.text_box value, options
        end
        
        pdf.start_new_page :template => @template, :template_page => 1
          
        pdf.t @entity.coh_name_prefix, :at => [108, 618]
        pdf.t @entity.coh_name_first, :at => [208, 618]
        pdf.t @entity.coh_name_mi, :at => [350, 618]
        pdf.t @entity.coh_name_nick, :at => [108, 585]
        pdf.t @entity.coh_name_last, :at => [208, 585]
        pdf.t @entity.coh_name_suffix, :at => [350, 585]
        
        pdf.t @entity.coh_address.join("\n"), :at => [108, 548]
        
        pdf.t "X", :at => [10, 520] #  if @entity.coh_address_changed
          
#property :coh_phone, String, :required => true, :format => :telno

      end
      
      return fn
    end
    
    def self.produce_spac_20110928
      raise "sorry, not implemented yet"
    end
    
    
  end
end