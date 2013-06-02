require 'spec_helper'

describe Contribution do
  
  before(:each) do
    @c = FactoryGirl.build(:contribution)
  end
  
  subject { @c }
    
  describe "#valid?" do
    it { should validate }
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
      
    it "requires ContributorType::INDIVIDUAL for FormType::C" do
      @c.form_type = FormType::C
      @c.contributor_type = ContributorType::ENTITY
      should_not accept_attribute_value(:contributor_type, ContributorType::INDIVIDUAL)
    end
    
    it "requires ContributorType::INDIVIDUAL for FormType::D" do
      @c.form_type = FormType::D
      @c.contributor_type = ContributorType::ENTITY
      should_not accept_attribute_value(:contributor_type, ContributorType::INDIVIDUAL)
    end
  end
        
  describe "#contributor_type is INDIVIDUAL" do
    
    before(:each) do
      @c.contributor_type = ContributorType::INDIVIDUAL
      should validate
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
      should validate
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
  
  describe "#is_out_of_state_pac" do
    it { should_not accept_attribute_value(:is_out_of_state_pac, nil) }
    it { should accept_attribute_value(:is_out_of_state_pac, false) }
    it { should accept_attribute_value(:is_out_of_state_pac, true) }
    it "cannot be set for FormType::AL" do
      @c.is_out_of_state_pac = true
      should_not accept_attribute_value(:form_type,  FormType::AL)
    end
    it "cannot be set for FormType::C" do
      @c.is_out_of_state_pac = true
      should_not accept_attribute_value(:form_type,  FormType::C)
    end            
  end
  
  describe "#out_of_state_pac_id" do
    describe "when is_out_of_state_pac is false" do
      it { should_not require_attribute(:out_of_state_pac_id) } 
      it { should_not accept_attribute_value(:out_of_state_pac_id, "C12345678") } 
    end
    describe "when is_out_of_state_pac is true" do
      before(:each) do
        @c.is_out_of_state_pac = true
        @c.out_of_state_pac_id = "C12345678"
      end      
      # See note in Contribution validations as to why I'm treating this as not required.
      it { should_not require_attribute(:out_of_state_pac_id) }
      it { should_not accept_attribute_value(:out_of_state_pac_id, "xxxxxxxxx") } 
      it { should_not accept_attribute_value(:out_of_state_pac_id, "C1234567") }  
      it { should_not accept_attribute_value(:out_of_state_pac_id, "C123456789") }      
    end
  end
  
  describe "#date" do
    it { should require_attribute(:date) }    
    it { should accept_attribute_value(:date, Date.new(2010, 1, 1)) }
    it { should_not accept_attribute_value(:date, "cupcakes") }
  end
  
  describe "#amount" do
    it { should require_attribute(:amount) }
    it { should_not accept_attribute_value(:amount, -1.00) }
    it { should_not accept_attribute_value(:amount, 0.00) }
    it { should accept_attribute_value(:amount, 0.01) }
    it { should accept_attribute_value(:amount, 999999999.99) }
    it { should_not accept_attribute_value(:amount, 1000000000.00) }
    it { should_not accept_attribute_value(:amount, "cupcakes") }
  end
  
  describe "#in_kind_description" do
    it { should_not require_attribute(:in_kind_description) }
    it { should accept_attribute_length(:in_kind_description, 100) }
    it { should_not accept_attribute_length(:in_kind_description, 100+1) }
  end
  
  describe "#employer" do
    it { should_not require_attribute(:employer) }
    it { should accept_attribute_length(:employer, 60) }
    it { should_not accept_attribute_length(:employer, 60+1) }
    it "is required for FormType::AJ" do
      @c.form_type = FormType::AJ
      @c.employer = "self"
      @c.occupation = "ditchdigger"
      should require_attribute(:employer)
    end
    it "must be blank for FormType::AL" do
      @c.form_type = FormType::AL
      should_not accept_attribute_value(:employer, "x")
    end
    it "must be blank for FormType::C" do
      @c.form_type = FormType::C
      @c.contributor_type = ContributorType::ENTITY
      should_not accept_attribute_value(:employer, "x")
    end
  end
  
  describe "#occupation" do
    it { should_not require_attribute(:occupation) }
    it { should accept_attribute_length(:occupation, 60) }
    it { should_not accept_attribute_length(:occupation, 60+1) }
  end

end
