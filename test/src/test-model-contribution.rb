$:.insert(0, "#{File.dirname(__FILE__)}/../../lib")
require "minitest/autorun"
require "tecfiler"

require "pp"
    
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
  }
  
  PARAMS_CONTRIBUTION = {
    :rec_type => :RECEIPT,
    :form_type => :A1,
    :entity_code => :INDIVIDUAL,
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
  
  def setup
    @coh = TECFiler::Model::COH.create(PARAMS_COH)
  end
  
  def test_new
    c = TECFiler::Model::Contribution.new(PARAMS_CONTRIBUTION)
    c.coh = @coh
    assert c.valid?, "validation failed: #{c.errors.to_h}"      
  end
    
  
  def path_datafile(name)
    "#{File.dirname($0)}/../data/#{name}" 
  end
  
  def do_import_test(filename, options = {})
    csv = CSV.open(filename, :headers => TECFiler::Model::Contribution::IMPORT_COLS, :skip_blanks => true)
    csv.each do |row|
      c = TECFiler::Model::Contribution.from_import_row(row, :skip_empty => true)  
      next if c.nil?
      c.coh = @coh
      assert c.valid?, "file=#{filename}, line=#{csv.lineno}, validation failed: #{c.errors.to_h}"      
      c.save if options[:save]
    end 
  end   
  
  def test_from_import_row_1
    do_import_test(path_datafile("sample_contribs.csv"))
  end
  
  def test_from_import_row_2
    do_import_test(path_datafile("Schedule_A.csv"))
  end
  
  def test_from_import_row_3
    do_import_test(path_datafile("Schedule_A.csv"), :save => true)
  end
  
end

# vi:et:ai:ts=2:sw=2