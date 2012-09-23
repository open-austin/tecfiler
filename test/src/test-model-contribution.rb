currdir = File.dirname(__FILE__)
$:.insert(0, "#{currdir}/../lib", "#{currdir}/../../lib")
require "minitest/autorun"
require "tecfiler"
require "test-support"
    
class TestModelContribution < MiniTest::Unit::TestCase
  
  def new_contribution_type_individual(params = {})
    TECFiler::Model::Contribution.new(TECFiler::Test::PARAMS_CONTRIBUTION.merge(params))
  end

  
  def new_contribution_type_entity(params = {})
    p1 = {:contributor_type => :ENTITY, :employer => nil, :occupation => nil}.merge(params)
    TECFiler::Model::Contribution.new(TECFiler::Test::PARAMS_CONTRIBUTION.merge(p1))
  end
  
  
  def setup
    @t = TECFiler::Test::EntityFieldAssertions.new(self, TECFiler::Model::Contribution, proc{new_contribution_type_individual})
  end
  

  def test01_new
    c = new_contribution_type_individual
    refute_nil c
    assert_instance_of TECFiler::Model::Contribution, c
    assert_entity_valid c
    refute c.saved?, "entity was unexpectedly saved" 
    assert_nil c.id
  end    
  
  
  def test02_create
    coh = TECFiler::Model::COH.create(TECFiler::Test::PARAMS_COH)
    refute_nil coh, "precondition failed"
      
    p = TECFiler::Test::PARAMS_CONTRIBUTION.merge(:unassociated => false, :coh => coh)
    c = TECFiler::Model::Contribution.create(p)
    refute_nil c
    assert_instance_of TECFiler::Model::Contribution, c
    assert_entity_valid c  
    assert c.saved?, "entity was not saved" 
    refute_nil c.id
  end    
  

  
  def test10_field_rec_type   
    @t.assert_required :rec_type, :value => :RECEIPT
    
    @t.refute_value_valid :rec_type, "cupcakes"
    @t.refute_value_valid :rec_type, :CUPCAKES
    
    [:RECEIPT, "receipt", "r", "R", "Rxxxxxxxx"].each do |value|    
      @t.assert_value_valid:rec_type, value, :verify_value => :RECEIPT
    end
    
    [:PLEDGE, "pledge", "p", "P", "Pxxxxxxxx"].each do |value|   
      @t.assert_value_valid:rec_type, value, :verify_value => :PLEDGE
    end
  end

  
  def test11_field_form_type
    %w(A B C D X).each do |x|
      %w(~ 0 1 2 3 4 J L X).each do |y|        
        form_type = (x + (y == "~" ? "" : y))  
        case form_type
        when "A1"
          @t.assert_value_valid:form_type, form_type, :entity => proc{new_contribution_type_individual}, :verify_value => :A1
          @t.assert_value_valid:form_type, form_type, :entity => proc{new_contribution_type_entity}, :verify_value => :A1
        when "B1"
          @t.assert_value_valid:form_type, form_type, :entity => proc{new_contribution_type_individual}, :verify_value => :B1
          @t.assert_value_valid:form_type, form_type, :entity => proc{new_contribution_type_entity}, :verify_value => :B1
        when "C"
          @t.refute_value_valid :form_type, form_type, :entity => proc{new_contribution_type_individual}, :reject_field => :contributor_type
          @t.assert_value_valid:form_type, form_type, :entity => proc{new_contribution_type_entity}, :verify_value => :C
        else
          @t.refute_value_valid :form_type, form_type, :entity => proc{new_contribution_type_individual}
          @t.refute_value_valid :form_type, form_type, :entity => proc{new_contribution_type_entity}
        end          
      end
    end
    
  end
  
  
  def test12_field_contributor_type
    @t.assert_required :contributor_type, :value => :INDIVIDUAL
    @t.refute_value_valid :contributor_type, "cupcakes"
    @t.refute_value_valid :contributor_type, :CUPCAKES
    [:INDIVIDUAL, "individual", "i", "I", "ixx", "IXX"].each do |value| 
      @t.assert_value_valid:contributor_type, value, :verify_value => :INDIVIDUAL
    end
    [:ENTITY, "entity", "e", "E", "exx", "EXX"].each do |value|    
      @t.assert_value_valid:contributor_type, value, :verify_value => :ENTITY
    end
  end

  
  def test20_field_name_title
    @t.assert_optional :name_title
    @t.assert_max_length :name_title, 25    
    @t.assert_not_allowed :name_title, :entity => proc {new_contribution_type_entity}
  end
  
  
  def test21_field_name_first
    @t.assert_required :name_first
    @t.assert_max_length :name_first, 45
    @t.assert_optional :name_first, :entity => proc {new_contribution_type_entity}
  end


  def test22_field_name_last
    @t.assert_required :name_last
    @t.assert_max_length :name_last, 100  
    @t.assert_required :name_last, :entity => proc {new_contribution_type_entity}
  end


  def test23_field_name_suffix
    @t.assert_optional :name_suffix
    @t.assert_max_length :name_suffix, 10    
    @t.assert_not_allowed :name_suffix, :entity => proc {new_contribution_type_entity}
  end  
 

  def test30_field_address
    @t.assert_required :address
    @t.assert_max_length :address, 55    
    @t.assert_required :address, :entity => proc {new_contribution_type_entity}
  end

  
  def test31_field_address2
    @t.assert_optional :address2
    @t.assert_max_length :address2, 55    
    @t.assert_optional :address2, :entity => proc {new_contribution_type_entity}
  end

  
  def test32_field_city
    @t.assert_required :city
    @t.assert_max_length :city, 30    
    @t.assert_required :city, :entity => proc {new_contribution_type_entity}
  end


  def test33_field_state    
    @t.refute_value_valid :state, "T"
    @t.assert_value_valid:state, "TX"
    @t.assert_value_valid:state, "tx", :verify_value => "TX"
    @t.refute_value_valid :state, "Txx"
    @t.refute_value_valid :state, "Texas"
      
    @t.assert_required :state, :value => "TX"
    @t.assert_required :state, :value => "TX", :entity => proc {new_contribution_type_entity}
  end
  
  
  def test34_field_zip
    @t.assert_value_valid:zip, "78701"
    @t.assert_value_valid:zip, "78701-0000"
    
    %w(cupcakes 7870 787010000 78701-000 78701-00000 7870-0000 787010-0000).each do |value|
      @t.refute_value_valid :zip, value
    end

    @t.assert_required :zip, :value => "78701"
    @t.assert_required :zip, :value => "78701", :entity => proc {new_contribution_type_entity}
  end
  
  
  def test41_field_is_out_of_state_pac
    @t.assert_value_valid:is_out_of_state_pac, true, :entity => proc {
      new_contribution_type_entity(:pac_id => "xyz")
    }
    @t.assert_value_valid:is_out_of_state_pac, false
    @t.assert_value_valid:is_out_of_state_pac, nil
    @t.refute_value_valid :form_type, :AL, :reject_field => :is_out_of_state_pac, :entity => proc {  
      new_contribution_type_entity(:is_out_of_state_pac => true, :pac_id => "xyz") 
    }
    @t.refute_value_valid :form_type, :C, :reject_field => :is_out_of_state_pac, :entity => proc {  
      new_contribution_type_entity(:is_out_of_state_pac => true, :pac_id => "xyz") 
    }
  end
  

  def test42_field_pac_id
    @t.assert_required :pac_id, :entity => proc {
      new_contribution_type_entity(:is_out_of_state_pac => true, :pac_id => "xyz") 
    }

    @t.refute_value_valid :form_type, :AL, :reject_field => :pac_id, :entity => proc {  
      new_contribution_type_entity(:is_out_of_state_pac => true, :pac_id => "xyz") 
    }
    @t.refute_value_valid :form_type, :C, :reject_field => :pac_id, :entity => proc {  
      new_contribution_type_entity(:is_out_of_state_pac => true, :pac_id => "xyz") 
    }
  end
  
  
  def test51_field_date
    # not done
  end
  
  
  def test52_field_amount
    # not done
  end
  
  def test53_field_in_kind_description
    @t.assert_optional :in_kind_description
    @t.assert_max_length :in_kind_description, 100
  end
  
  def test54_field_employer
    # not done
  end
  
  def test55_field_occupation
    # not done
  end
     

#  
#property :date, Date, :required => true
#property :amount, Decimal, :precision => 12, :scale => 2, :required => true
#property :in_kind_description, String, :length => 100
#property :employer, String, :length => 60
#  validates_presence_of :employer, :if => lambda{|t| [:AJ].include?(t.form_type)}  
#  validates_absence_of :employer, :if => lambda{|t| [:AL, :C].include?(t.form_type)} 
#property :occupation, String, :length => 60
#  validates_presence_of :occupation, :if => lambda{|t| [:A2, :AJ].include?(t.form_type)}  
#  validates_absence_of :occupation, :if => lambda{|t| [:AL, :C].include?(t.form_type)} 
    

  
#  def test81_from_import_row
#    fail("not implemented")
#  end
#  
#  def test82_validate_from_import_row
#    fn = TECFiler::Test::PATH_SAMPLE_DATA_CONTRIBUTIONS
#    csv = TECFiler::ImportFile.open(fn, :import_type => :contributions)
#    csv.each do |row|
#      e = TECFiler::Model::Contribution.validate_import_row(row, :unassociated)
#      assert_nil e, "validation failed: record=#{csv.lineno}, #{e ? e.to_h : nil}"
#    end
#  end
#  
#  def test83_create_from_import_row
#    coh = TECFiler::Test::new_coh(:create => true)          
#    fn = TECFiler::Test::PATH_SAMPLE_DATA_CONTRIBUTIONS 
#    csv = TECFiler::ImportFile.open(fn, :import_type => :contributions)
#    csv.each do |row|
#      c = TECFiler::Model::Contribution.create_from_import_row(row, coh)
#      refute_nil c, "create_from_import_row failed"
#      assert c.saved?, "save failed: record=#{csv.lineno}, #{c.errors.to_h}"  
#    end
#  end

  
end

# vi:et:ai:ts=2:sw=2