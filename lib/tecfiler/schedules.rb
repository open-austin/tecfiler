
module TECFiler
  module Schedule
    
    class GenericSchedule
      
      attr_reader :pdf
      attr_reader :dataset
      
      attr_reader :template_file
      attr_reader :template_page
      attr_reader :entries_per_page
      attr_reader :entry_height
      attr_reader :num_recs
      attr_reader :num_pages
      
      def initialize(pdf, dataset, attrs)
        @pdf = pdf
        @dataset = dataset
        
        @template_file = attrs[:template_file] or raise "required attribute :template_file not defined"
        @template_page = attrs[:template_page] or raise "required attribute :template_page not defined"
        @entries_per_page = attrs[:entries_per_page] or raise "required attribute :entries_per_page not defined"
        @entry_height = attrs[:entry_height] or raise "required attribute :entry_height not defined"

        @num_recs = @dataset.count
        @num_pages = (@num_recs + @entries_per_page-1) / @entries_per_page
      end
      

      def produce
        return unless @num_recs > 0        
        pageno = 0
        entryno = 0
        @dataset.each do |entry|
          idx = (entryno % @entries_per_page)
          entryno += 1
          if idx == 0
            pageno += 1
            @pdf.start_new_page :template => @template_file, :template_page => @template_page
            emit_page_header(pageno)
          end          
          offset = idx * @entry_height
          emit_entry(offset, entry) 
        end # @dataset.each    
      end # produce
      
      def emit_page_header
        raise "method must be overridden"
      end
      protected :emit_page_header

      def emit_entry
        raise "method must be overridden"
      end
      protected :emit_entry
      
      
      #
      # given X/Y coordinates, origin top-left, 72 units per inch
      # convert to X/Y coordinates, orgin bottom-left, 72 units per inch
      #
      # I got the given coordinates by loading the PDF form into GIMP and
      # hovering over the location to place the text.
      #
      def field(x, y, value)
        return if value.nil? || value.empty?
        x1 = x - 37
        y1 = (11*72) - y - 30
        @pdf.text_box value, :at => [x1, y1]
      end
      protected :field
      
    end # class GenericSchedule

    
    class A < GenericSchedule
      
      attr_reader :entity
      
      def initialize(pdf, entity, dataset, attrs = {})
        super(pdf, dataset, {
          :template_file => TECFiler::FormGenerator::BASEDIR_FORMS + "/state.tx.us/20110928/coh.pdf",
          :template_page => 3,
          :entries_per_page => 5,
          :entry_height => 108,
        }.merge(attrs))
        @entity = entity
      end
      
      def emit_page_header(pageno)
        field 408, 114, "#{pageno} of #{@num_pages}"
        field 54, 143, @entity.coh_name
      end  
      
      def emit_entry(offset, entry) 
        y = 160
        field  48, y+offset+16, entry.date.strftime("%m/%d/%Y")
        field 128, y+offset+16, entry.name
        field 232, y+offset+0, "X" if entry.is_out_of_state_pac
        field 302, y+offset+0, entry.pac_id
        field 128, y+offset+43, entry.full_address.join("\n")
        field 396, y+offset+19, "%.2f" % [entry.amount]
        field 468, y+offset+19, entry.in_kind_description
        field  54, y+offset+90, entry.occupation
        field 328, y+offset+90, entry.employer
      end
      
    end # TECFiler::Schedule::A
    

    class B < GenericSchedule
      
      attr_reader :entity
      
      def initialize(pdf, entity, dataset, attrs = {})
        super(pdf, dataset, {
          :template_file => TECFiler::FormGenerator::BASEDIR_FORMS + "/state.tx.us/20110928/coh.pdf",
          :template_page => 4,
          :entries_per_page => 5,
          :entry_height => 114,
        }.merge(attrs))
        @entity = entiry
      end

      def emit_page_header(pageno)

        pdf.start_new_page :template => @template, :template_page => 1  
        field 408, 114, "#{pageno} of #{npages}"
        field  54, 143, @entity.coh_name
        field 488, 170, "%.2f" % unitimized_pledges if pageno == 1
      end 

      def emit_entry(offset, entry) 
        # these fields are the same as sched A, just 26pts lower down the page 
        # FIXME - DRY!!!!         
        y = 160+26
        field  48, y+offset+16, entry.date.strftime("%m/%d/%Y")
        field 128, y+offset+16, entry.name
        field 232, y+offset+0, "X" if entry.is_out_of_state_pac
        field 302, y+offset+0, entry.pac_id
        field 128, y+offset+43, entry.full_address.join("\n")
        field 396, y+offset+19, "%.2f" % [entry.amount]
        field 468, y+offset+19, entry.in_kind_description
        field  54, y+offset+90, entry.occupation
        field 328, y+offset+90, entry.employer
      end
      
    end # TECFiler::Schedule::B


  end # module Schedule
end # module TECFiler