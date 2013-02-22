require "prawn"
require "tempfile"

module TECFiler
  class FormGenerator
    
    BASEDIR_FORMS = File.dirname(__FILE__) + "/forms"
    
    def self.produce(outfile, entity, options = {})
      
      @outfile = outfile
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
      
      Prawn::Document.generate(@outfile) do |pdf|
      
        sched_a = TECFiler::Schedule::A.new(pdf, @entity,
          @entity.contributions.all(:form_type => [:A1, :A2, :AJ, :AL]))
        sched_b = TECFiler::Schedule::A.new(pdf, @entity,
          @entity.contributions.all(:form_type => [:B1, :B2, :B3, :BJ]))

          
        # calculated values
        npages = 999
        unitimized_pledges = 0
        total_contributions_small = 0
        total_contributions_itemized = @entity.contributions.sum(:amount) || 0
        total_expenditures_small = 0
        total_expenditures_itemized = @entity.expenditures.sum(:amount) || 0
        balance_contributions = 0
        outstanding_loans = 0
        
        pdf.text_box "TECFiler report for COH entity id #{@entity.id}"
        
        #
        # given X/Y coordinates, origin top-left, 72 units per inch
        # convert to X/Y coordinates, orgin bottom-left, 72 units per inch
        #
        # I got the given coordinates by loading the PDF form into GIMP and
        # hovering over the location to place the text.
        #
        def pdf.t(x, y, value)          
          return if value.empty?
          x1 = x - 37
          y1 = (11*72) - y - 30
          self.text_box value, :at => [x1, y1]
        end

        #
        # COH page 1/2
        #
        
        pdf.start_new_page :template => @template, :template_page => 1  
        
        pdf.t 451, 116, npages.to_s      
          
        pdf.t 144, 150, @entity.coh_name_prefix
        pdf.t 244, 150, @entity.coh_name_first
        pdf.t 387, 150, @entity.coh_name_mi
        pdf.t 144, 182, @entity.coh_name_nick
        pdf.t 244, 182, @entity.coh_name_last
        pdf.t 387, 182, @entity.coh_name_suffix
        
        pdf.t 144, 220, @entity.coh_address.join("\n")
        
        pdf.t  48, 249,  "X" if @entity.coh_address_changed
        
        pdf.t 220, 280, @entity.coh_phone          

        pdf.t 144, 314, @entity.treasurer_name_prefix
        pdf.t 244, 314, @entity.treasurer_name_first
        pdf.t 387, 314, @entity.treasurer_name_mi
        pdf.t 144, 346, @entity.treasurer_name_nick
        pdf.t 244, 346, @entity.treasurer_name_last
        pdf.t 387, 346, @entity.treasurer_name_suffix

        pdf.t 144, 383, @entity.treasurer_address.join("\n")

        pdf.t 220, 450, @entity.treasurer_phone        
        
        pdf.t 145, 506, "X" if @entity.report_type == :JAN15
        pdf.t 223, 506, "X" if @entity.report_type == :ELECTION_30DAY
        pdf.t 336, 506, "X" if @entity.report_type == :RUNNOFF
        pdf.t 435, 506, "X" if @entity.report_type == :TREASURER_APPT
        pdf.t 145, 531, "X" if @entity.report_type == :JUL15
        pdf.t 223, 531, "X" if @entity.report_type == :ELECTION_8DAY
        pdf.t 336, 531, "X" if @entity.report_type == :EXCEED_500
        pdf.t 435, 531, "X" if @entity.report_type == :FINAL
        
        pdf.t 141, 581, @entity.period_begin.month.to_s
        pdf.t 185, 581, @entity.period_begin.day.to_s
        pdf.t 222, 581, @entity.period_begin.year.to_s
   
        pdf.t 366, 581, @entity.period_end.month.to_s
        pdf.t 410, 581, @entity.period_end.day.to_s
        pdf.t 444, 581, @entity.period_end.year.to_s
        
        unless @entity.election_date.nil?  
          pdf.t 141, 642, @entity.election_date.month.to_s
          pdf.t 185, 642, @entity.election_date.day.to_s
          pdf.t 222, 642, @entity.election_date.year.to_s
        end

        pdf.t 262, 629, "X" if @entity.election_type == :PRIMARY
        pdf.t 335, 629, "X" if @entity.election_type == :RUNOFF
        pdf.t 416, 629, "X" if @entity.election_type == :GENERAL
        pdf.t 504, 629, "X" if @entity.election_type == :SPECIAL
        
        pdf.t 141, 684, @entity.office_held
        pdf.t 353, 684, @entity.office_sought       

        #
        # COH page 2/2
        #
        
        pdf.start_new_page :template => @template, :template_page => 2  
        
        pdf.t 54, 115, @entity.coh_name
        # XXX - the whitespace padding appears to be lost below
        pdf.t 470, 357, "%-12.2f" % [total_contributions_small]
        pdf.t 470, 388, "%-12.2f" % [total_contributions_itemized]
        pdf.t 470, 421, "%-12.2f" % [total_expenditures_small]
        pdf.t 470, 453, "%-12.2f" % [total_expenditures_itemized]
        pdf.t 470, 484, "%-12.2f" % [balance_contributions]
        pdf.t 470, 517, "%-12.2f" % [outstanding_loans]
        
        sched_a.produce
        sched_b.produce      
      
      end
      
    end
    
    
    def self.produce_spac_20110928
      raise "sorry, not implemented yet"
    end
    
    
  end
end