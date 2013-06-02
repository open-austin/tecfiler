require 'spec_helper'

describe Contribution do
  
  before(:each) do
    @c = FactoryGirl.build(:contribution)
  end
  
  subject { @c }

  describe "#valid?" do
    it { should be_valid }
  end
  
  describe "#rec_type" do
    it { should require_attribute(:rec_type) }
    it { should accept_attribute_value(:rec_type, ContributionType::RECEIPT) }
    it { should accept_attribute_value(:rec_type, ContributionType::PLEDGE) }
    it { should_not accept_attribute_value(:rec_type, "CUPCAKES") }
  end  

  describe "#form_type" do
    it { should require_attribute(:form_type) }
    it { should accept_attribute_value(:form_type, FormType::A1) }
    it { should accept_attribute_value(:form_type, FormType::B1) }
    it { should_not accept_attribute_value(:form_type, "CUPCAKES") }    
  end
  
  describe "#contributor_type" do
    it { should require_attribute(:contributor_type) }
    it { should accept_attribute_value(:contributor_type, ContributorType::INDIVIDUAL) }
    it { should accept_attribute_value(:contributor_type, ContributorType::ENTITY) }
    it { should_not accept_attribute_value(:contributor_type, "CUPCAKES") }
  end
  
  describe "#contributor_type is INDIVIDUAL" do
    
    before(:each) do
      @c.contributor_type = ContributorType::INDIVIDUAL
      should be_valid
    end
        
    describe "#name_title" do
      it { should_not require_attribute(:name_title) }
      it { should accept_attribute_length(:name_title, 25) }
      it { should_not accept_attribute_length(:name_title, 25+1) }
    end
  
    describe "#name_first" do
      it { should require_attribute(:name_first) }
      it { should accept_attribute_length(:name_first, 45) }
      it { should_not accept_attribute_length(:name_first, 45+1) }
    end

    describe "#name_last" do
      it { should require_attribute(:name_last) }
      it { should accept_attribute_length(:name_last, 100) }
      it { should_not accept_attribute_length(:name_last, 100+1) }
    end

    describe "#name_suffix" do
      it { should_not require_attribute(:name_suffix) }
      it { should accept_attribute_length(:name_suffix, 10) }
      it { should_not accept_attribute_length(:name_suffix, 10+1) }
    end
    
  end # "#contributor_type is INDIVIDUAL"

  describe "#contributor_type is ENTITY" do
    
    before(:each) do
      @c.contributor_type = ContributorType::ENTITY
      should be_valid
    end
        
    describe "#name_title" do
      it { should_not require_attribute(:name_title) }
      it { should_not accept_attribute_length(:name_title, 1) }
    end
  
    describe "#name_first" do
      it { should_not require_attribute(:name_first) }
      it { should accept_attribute_length(:name_first, 45) }
      it { should_not accept_attribute_length(:name_first, 45+1) }
    end

    describe "#name_last" do
      it { should require_attribute(:name_last) }
      it { should accept_attribute_length(:name_last, 100) }
      it { should_not accept_attribute_length(:name_last, 100+1) }
    end

    describe "#name_suffix" do
      it { should_not require_attribute(:name_suffix) }
      it { should_not accept_attribute_length(:name_suffix, 1) }
    end
    
  end # "#contributor_type is ENTITY"
  
  describe "#address" do
    it { should require_attribute(:address) }
    it { should accept_attribute_length(:address, 55) }
    it { should_not accept_attribute_length(:address, 55+1) }
  end
    
  describe "#address2" do
    it { should_not require_attribute(:address2) }
    it { should accept_attribute_length(:address2, 55) }
    it { should_not accept_attribute_length(:address2, 55+1) }
  end

  describe "#city" do
    it { should require_attribute(:city) }
    it { should accept_attribute_length(:city, 30) }
    it { should_not accept_attribute_length(:city, 30+1) }
  end

  describe "#state" do
    it { should require_attribute(:state) }
    it { should_not accept_attribute_value(:state, "X") }
    it { should accept_attribute_value(:state, "XX") }
    it { should_not accept_attribute_value(:state, "XXX") }
  end
  
  describe "#zip" do
    it { should require_attribute(:zip) }
    it { should accept_attribute_value(:zip, "12345") }
    it { should_not accept_attribute_value(:zip, "123456") }
    it { should_not accept_attribute_value(:zip, "xxxxx") }
    it { should accept_attribute_value(:zip, "12345-6789") }
    it { should_not accept_attribute_value(:zip, "12345-67890") }
    it { should_not accept_attribute_value(:zip, "123456789") }
  end

#    
#    def test41_field_is_out_of_state_pac
#      @t.assert_value_valid :is_out_of_state_pac, true, :entity => proc {
#        new_contribution_type_entity(:pac_id => "xyz")
#      }
#      @t.assert_value_valid :is_out_of_state_pac, false
#      @t.assert_value_valid :is_out_of_state_pac, nil
#      @t.refute_value_valid :form_type, :AL, :reject_field => :is_out_of_state_pac, :entity => proc {  
#        new_contribution_type_entity(:is_out_of_state_pac => true, :pac_id => "xyz") 
#      }
#      @t.refute_value_valid :form_type, :C, :reject_field => :is_out_of_state_pac, :entity => proc {  
#        new_contribution_type_entity(:is_out_of_state_pac => true, :pac_id => "xyz") 
#      }
#    end
#    
#  
#    def test42_field_pac_id
#      @t.assert_required :pac_id, :entity => proc {
#        new_contribution_type_entity(:is_out_of_state_pac => true, :pac_id => "xyz") 
#      }
#  
#      @t.refute_value_valid :form_type, :AL, :reject_field => :pac_id, :entity => proc {  
#        new_contribution_type_entity(:is_out_of_state_pac => true, :pac_id => "xyz") 
#      }
#      @t.refute_value_valid :form_type, :C, :reject_field => :pac_id, :entity => proc {  
#        new_contribution_type_entity(:is_out_of_state_pac => true, :pac_id => "xyz") 
#      }
#    end
#    
#    
#    def test51_field_date
#      # import spec defines format: YYYYMMDD
#      @t.assert_value_valid :date, "20120110", :expect_value => Date.new(2012, 1, 10)
#      @t.assert_required :date, :value => "20120110", :expect_value => Date.new(2012, 1, 10)
#      
#      # accept some additional formats
#      @t.assert_value_valid :date, "2012-01-10", :expect_value => Date.new(2012, 1, 10)
#      @t.assert_value_valid :date, "2012-Jan-10", :expect_value => Date.new(2012, 1, 10)
#      @t.assert_value_valid :date, "10 Jan 2012", :expect_value => Date.new(2012, 1, 10)
#      @t.assert_value_valid :date, "Jan 10, 2012", :expect_value => Date.new(2012, 1, 10)
#      @t.assert_value_valid :date, "Jan 10", :expect_value => Date.new(Time.now.year, 1, 10)
#      
#      # the Data parser is extremely tolerant, and for better or worse accepts very loosely
#      @t.refute_value_valid :date, "cupcakes"
#      @t.refute_value_valid :date, "20123001"
#      @t.refute_value_valid :date, "2012-30-01"
#      @t.refute_value_valid :date, "201201100"
#  
#    end
#    
#    
#    def test52_field_amount
#      @t.assert_value_valid :amount, "100", :expect_value => 100.00
#      @t.assert_required :amount, :value => "100", :expect_value => 100.00    
#  
#      @t.assert_value_valid :amount, "0.01", :expect_value => 0.01
#      @t.assert_value_valid :amount, "100", :expect_value => 100.00
#      @t.assert_value_valid :amount, "100.1", :expect_value => 100.10
#      @t.assert_value_valid :amount, "100.15", :expect_value => 100.15    
#  
#      @t.assert_value_valid :amount, "999999", :expect_value => 999999.00
#      @t.assert_value_valid :amount, "9999999", :expect_value => 9999999.00
#      @t.assert_value_valid :amount, "99999999", :expect_value => 99999999.00
#      
#      # we allow thousand seperator (',') in value assignments
#      @t.assert_value_valid :amount, "99,999,999", :expect_value => 99999999.00
#      
#      @t.refute_value_valid :amount, "cupcakes"
#      @t.refute_value_valid :amount, "100.159"
#  
#      # precision = 12, scale = 2
#      @t.assert_value_valid :amount, "1000000000", :expect_value => 1000000000.00
#      @t.assert_value_valid :amount, "9999999999", :expect_value => 9999999999.00
#      @t.assert_value_valid :amount, "9999999999.99", :expect_value => 9999999999.99
#      @t.refute_value_valid :amount, "10000000000"      
#  
#    end
#    
#    
#    def test53_field_in_kind_description
#      @t.assert_optional :in_kind_description
#      @t.assert_max_length :in_kind_description, 100
#    end
#    
#    
#    def test54_field_employer
#      @t.assert_optional :employer
#      @t.assert_max_length :employer, 60
#  
#      skip_test_because ! form_type_allowed?(:AJ) do
#        @t.assert_required :employer, :entity => proc {new_contribution_type_individual(:form_type => :AJ)}
#      end
#      skip_test_because ! form_type_allowed?(:AL) do
#        @t.assert_not_allowed :employer, :entity => proc {new_contribution_type_individual(:form_type => :AL)}
#      end
#      perform_test_because form_type_allowed?(:C) do
#        @t.assert_not_allowed :employer, :entity => proc {new_contribution_type_entity(:form_type => :C)}
#      end
#    end
#    
#    
#    def test55_field_occupation
#      @t.assert_optional :occupation
#      @t.assert_max_length :occupation, 60
#      
#      skip_test_because ! form_type_allowed?(:A2) do
#        @t.assert_required :occupation, :entity => proc {new_contribution_type_individual(:form_type => :A2)}
#      end
#      skip_test_because ! form_type_allowed?(:AJ) do
#        @t.assert_required :occupation, :entity => proc {new_contribution_type_individual(:form_type => :AJ)}
#      end
#      skip_test_because ! form_type_allowed?(:AL) do
#        @t.assert_not_allowed :occupation, :entity => proc {new_contribution_type_individual(:form_type => :AL)}
#      end
#      perform_test_because form_type_allowed?(:C) do
#        @t.assert_not_allowed :occupation, :entity => proc {new_contribution_type_entity(:form_type => :C)}
#      end
#    end
#       
#    
  
end
