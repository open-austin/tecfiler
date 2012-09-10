currdir = File.dirname(__FILE__)
$:.insert(0, "#{currdir}/../lib", "#{currdir}/../../lib")
require "minitest/autorun"
require "tecfiler"
require "test-support"
    
class TestModelContribution < MiniTest::Unit::TestCase
  
  def setup
    # empty
  end

  def test01_new
    c = TECFiler::Model::Contribution.new(TECFiler::Test::PARAMS_CONTRIBUTION)   
    refute_nil c
    assert_instance_of TECFiler::Model::Contribution, c
    assert c.valid?(:unassociated), "entity does not validate: #{c.errors.to_h}" 
    refute c.saved?, "entity was unexpectedly saved" 
  end    
  
  def test02_create
    coh = TECFiler::Test::new_coh(:create => true)
    p = TECFiler::Test::PARAMS_CONTRIBUTION.merge(:coh => coh)
    c = TECFiler::Model::Contribution.create(p) 
    refute_nil c
    assert_instance_of TECFiler::Model::Contribution, c
    assert c.valid?, "entity does not validate: #{c.errors.to_h}"  
    assert c.saved?, "entity was not saved" 
  end    
  
  def test12_field_rec_type
    c = TECFiler::Model::Contribution.new(TECFiler::Test::PARAMS_CONTRIBUTION)
    assert c.valid?(:unassociated), "precondition failed: entity does not validate: #{c.errors.to_h}" 
      
    c.rec_type = nil
    refute c.valid?(:unassociated), "entity passes validation with rec_type=\"#{c.rec_type}\""
    
    c.rec_type = ""
    refute c.valid?(:unassociated), "entity passes validation with rec_type=\"#{c.rec_type}\""
      
    c.rec_type = :RECEIPT
    assert c.valid?(:unassociated), "entity does not validate: #{c.errors.to_h}" 
    assert_equal :RECEIPT, c.rec_type

    c.rec_type = :PLEDGE
    assert c.valid?(:unassociated), "entity does not validate: #{c.errors.to_h}" 
    assert_equal :PLEDGE, c.rec_type

    c.rec_type = :CUPCAKES
    refute c.valid?(:unassociated), "entity passes validation with rec_type=\"#{c.rec_type}\""
    
    c.rec_type = "r"
    assert c.valid?(:unassociated), "entity does not validate: #{c.errors.to_h}" 
    assert_equal :RECEIPT, c.rec_type
    
    c.rec_type = "R"
    assert c.valid?(:unassociated), "entity does not validate: #{c.errors.to_h}" 
    assert_equal :RECEIPT, c.rec_type

    c.rec_type = "Rxxxxxxxx"
    assert c.valid?(:unassociated), "entity does not validate: #{c.errors.to_h}" 
    assert_equal :RECEIPT, c.rec_type

    c.rec_type = "p"
    assert c.valid?(:unassociated), "entity does not validate: #{c.errors.to_h}" 
    assert_equal :PLEDGE, c.rec_type

    c.rec_type = "P"
    assert c.valid?(:unassociated), "entity does not validate: #{c.errors.to_h}" 
    assert_equal :PLEDGE, c.rec_type

    c.rec_type = "Pxxx"
    assert c.valid?(:unassociated), "entity does not validate: #{c.errors.to_h}" 
    assert_equal :PLEDGE, c.rec_type

    c.rec_type = "cupcakes"
    refute c.valid?, "entity passes validation with rec_type=\"#{c.rec_type}\""

    c.rec_type = :RECEIPT
    assert c.valid?(:unassociated), "entity does not validate: #{c.errors.to_h}" 
    assert_equal :RECEIPT, c.rec_type
  end
  
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