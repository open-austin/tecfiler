$:.insert(0, "#{File.dirname($0)}/../../lib")
require "minitest/autorun"
require "tecfiler"

require "pp"
    
class TestModelContribution < MiniTest::Unit::TestCase
  
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
  
  def test_new
    c = TECFiler::Model::Contribution.new(PARAMS_CONTRIBUTION)
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