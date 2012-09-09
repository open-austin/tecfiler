$:.insert(0, "#{File.dirname(__FILE__)}/../../lib")
require "minitest/autorun"
require "tecfiler"
    
class TestModelContribution < MiniTest::Unit::TestCase

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
  }
  
  PARAMS_CONTRIBUTION = {
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
  }
  
  def test01_new
    c = TECFiler::Model::Contribution.new(PARAMS_CONTRIBUTION)
    assert c.valid?(:unassociated), "validation failed: #{c.errors.to_h}"      
  end
    
  PATH_SAMPLE_DATA_CONTRIBUTIONS = "#{File.dirname($0)}/../data/Schedule_A.csv"
  
  def test02_from_import_row_validate
    csv = TECFiler::ImportFile.open(PATH_SAMPLE_DATA_CONTRIBUTIONS, :import_type => :contributions)
    csv.each do |row|
      c = TECFiler::Model::Contribution.from_import_row(row)
      assert c.valid?(:unassociated), "record=#{csv.lineno}, validation failed: #{c.errors.to_h}"  
    end
  end
  
  def test02_from_import_row_save
    coh = TECFiler::Model::COH.new(PARAMS_COH)
    assert coh.valid?, "validation failed: #{coh.errors.to_h}"
      coh.save
      
    csv = TECFiler::ImportFile.open(PATH_SAMPLE_DATA_CONTRIBUTIONS, :import_type => :contributions)
    csv.each do |row|
      c = TECFiler::Model::Contribution.from_import_row(row, coh)
      assert c.valid?, "record=#{csv.lineno}, validation failed: #{c.errors.to_h}"
      c.save  
    end
  end

  
end

# vi:et:ai:ts=2:sw=2