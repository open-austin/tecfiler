module TECFiler
  module Test
    
    TESTDIR = File.dirname(__FILE__) + "/.."
    
    PATH_SAMPLE_DATA_CONTRIBUTIONS = "#{TESTDIR}/data/Schedule_A.csv"
    
    PARAMS_COH = {
      :coh_name_first => "Moe",
      :coh_name_last => "Howard",
      :coh_address_street => "100 Congress Ave",
      :coh_address_city => "Austin",
      :coh_address_state => "TX",
      :coh_address_zip  => "78701",
      :coh_phone  => "512-555-0000",
      :treasurer_name_first => "Larry",
      :treasurer_name_last => "Fine",
      :treasurer_address_street => "100 E 1st St",
      :treasurer_address_city => "Austin",
      :treasurer_address_state => "TX",
      :treasurer_address_zip  => "78701",
      :treasurer_phone  => "512-867-5309",
      :period_begin => "2012-01-01",
      :period_end => "2012-03-31",
      :report_type => :ELECTION_8DAY,
    }.freeze
    
    PARAMS_CONTRIBUTION = {
      :unassociated => true,
      :rec_type => :RECEIPT,
      :form_type => :A1,
      :contributor_type => :INDIVIDUAL,
      :name_first => "Moe",
      :name_last => "Howard",
      :address => "100 Congress Ave",
      :city => "Austin",
      :state => "TX",
      :zip => "78701",
      :date => "20120301",
      :amount => 31.41,
      :employer => "Dewey, Cheatem, and Howe",
      :occupation => "stooge",
    }.freeze
    

#    def self.new_thingy(klass, params)
#      if params.delete(:create)
#        thingy = klass.send(:create, params)  
#        raise "create \"#{klass}\" failed" unless thingy
#        raise "create \"#{klass}\" missing id value" unless thingy.id
#      else
#        thingy = klass.send(:new, params)
#        raise "new \"#{klass}\" failed" unless thingy
#        raise "create \"#{klass}\" unexpected id value" if thingy.id
#      end
#      thingy
#    end
#    
#    def self.new_coh(params = {})
#      new_thingy(TECFiler::Model::COH, PARAMS_COH.merge(params))
#    end
#    
#    def self.new_contribution(params = {})
#      new_thingy(TECFiler::Model::Contribution, PARAMS_CONTRIBUTION.merge(params))
#    end
    
    class EntityFieldAssertions
      
      def initialize(test_case, entity_class, default_initializer)
        @test_case = test_case
        @entity_class = entity_class # currently not used
        @default_initializer = default_initializer
      end      
    
      def option_value(options, key, default_value)
        options.has_key?(key) ? options[key] : default_value
      end
      private :option_value
    
      def create_entity(espec)
        entity = case espec
        when DataMapper::Resource
          espec
        when Proc
          espec.call
        when nil
          @default_initializer.call
        else
          @default_initializer.call(espec)
        end    
        @test_case.assert_entity_valid entity # precondition
        entity
      end
      private :create_entity
      
      
      # Verify entity passes validation when the specified field is assigned the specified value.
      #
      # Options:
      # * :entity -- Specifies entity to use for tests, instead of the default.
      # * :verify_value -- Verify field has this value after assignment. Default
      #   is the same value as assigned.
      #
      def assert_value_valid(field, value, options = {})
        entity = create_entity(options[:entity])
          
        setter = (field.to_s + "=").to_sym
        entity.send(setter, value)
        @test_case.assert_entity_valid entity
        
        expect_value = options.has_key?(:verify_value) ? options[:verify_value] : value
        @test_case.assert_equal expect_value,  entity.send(field)
      
        entity
      end
      
      # Verify entity fails validation when the specified field is assigned the specified value.
      #
      # Options:
      # * :entity -- Specifies entity to use for tests, instead of the default.
      # * :reject_field -- Verify this field (or, if list is given, all these fields)
      #   were rejected by validation. Default is to verify the field that was assigned.
      #
      def refute_value_valid(field, value, options = {})
        entity = create_entity(options[:entity])
        
        setter = (field.to_s + "=").to_sym
        entity.send(setter, value)
        @test_case.refute_entity_valid entity, :reject_field => option_value(options, :reject_field, field)      
        entity
      end
        
      
      def assert_required(field, options = {})
        assert_value_valid field, option_value(options, :value, "x"), options
        refute_value_valid field, option_value(options, :nil_value, nil), options
        refute_value_valid field, option_value(options, :empty_value, ""), options    
      end  
      
      
      def assert_optional(field, options = {})
        assert_value_valid field, option_value(options, :value, "x"), options
        assert_value_valid field, option_value(options, :nil_value, nil), options
        assert_value_valid field, option_value(options, :empty_value, ""), options
      end
      
      
      def assert_not_allowed(field, options = {})
        refute_value_valid field, option_value(options, :value, "x"), options
        assert_value_valid field, option_value(options, :nil_value, nil), options
        assert_value_valid field, option_value(options, :empty_value, ""), options
      end    
      
      
      def assert_max_length(field, maxlen, options = {})
        assert_value_valid field, "x" * maxlen, options
        refute_value_valid field, "x" * (maxlen+1), options
      end
    
      
      
    end # class EntityFieldAssertions
    
  end # module Test
end # module TECFiler

    
module MiniTest
  module Assertions
    
    def entity_validation_message(entity, problem)
      a = [problem + ":"]
      a << "model = \"#{entity.model}\""
      a << "errors = #{entity.errors.to_h}" if entity.errors
      a << "attributes = #{entity.attributes}"
      a.join("\n\t")
    end

    def assert_entity_valid(entity)
      refute_nil entity, proc {
        entity_validation_message(entity, "entity is nil")
      }        
      assert entity.valid?, proc {
        entity_validation_message(entity, "entity failed validation")
      }
    end
    
    def refute_entity_valid(entity, options = {}) 
      refute_nil entity, proc {
        entity_validation_message(entity, "entity is nil")
      }        
      refute entity.valid?, proc {
        entity_validation_message(entity, "invalid entity passed validation")
      }
      
      # ensure indicated field(s) were rejected by validations        
      if options.has_key?(:reject_field)
        [options[:reject_field]].flatten.each do |f|
          assert entity.errors.has_key?(f), proc {
            entity_validation_message(entity, "invalid entity field \"#{f}\" passed validation")
          } 
        end        
      end
      
      true
    end
    
    
  end # module Assertions
end # module MiniTest
