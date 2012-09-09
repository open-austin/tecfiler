currdir = File.dirname(__FILE__)
$:.insert(0, "#{currdir}/../lib", "#{currdir}/../../lib")
require "minitest/autorun"
require "tecfiler"
require "test-support"
    
class TestModelContribution < MiniTest::Unit::TestCase

  def test01_new
    c = TECFiler::Test::new_contribution
    assert c.valid?(:unassociated), "validation failed: #{c.errors.to_h}"      
  end    
  
  def test11_from_import_row
    fail("not implemented")
  end
  
  def test12_validate_from_import_row
    fn = TECFiler::Test::PATH_SAMPLE_DATA_CONTRIBUTIONS
    csv = TECFiler::ImportFile.open(fn, :import_type => :contributions)
    csv.each do |row|
      e = TECFiler::Model::Contribution.validate_import_row(row, :unassociated)
      assert_nil e, "validation failed: record=#{csv.lineno}, #{e ? e.to_h : nil}"
    end
  end
  
  def test13_create_from_import_row
    coh = TECFiler::Test::new_coh(:create => true)          
    fn = TECFiler::Test::PATH_SAMPLE_DATA_CONTRIBUTIONS 
    csv = TECFiler::ImportFile.open(fn, :import_type => :contributions)
    csv.each do |row|
      c = TECFiler::Model::Contribution.create_from_import_row(row, coh)
      refute_nil c, "create_from_import_row failed"
      assert c.saved?, "save failed: record=#{csv.lineno}, #{c.errors.to_h}"  
    end
  end

  
end

# vi:et:ai:ts=2:sw=2