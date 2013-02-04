$:.insert(0, "#{File.dirname(__FILE__)}/../../lib")
require "minitest/autorun"
require "tecfiler"
require "test-support"
    
class TestFormGenerator< MiniTest::Unit::TestCase
  
  # XXX - This is depending on other tests having run and created database.
  # Would be better if we create some mock data structures and use that.
  
  def test01_new
    g = TECFiler::FormGenerator.new(:COH)
    refute_nil g
    assert_instance_of TECFiler::FormGenerator, g
    assert_equal :produce_report_coh_20110928, g.instance_variable_get(:@produce_report)
    assert_equal "#{TECFiler::FormGenerator::BASEDIR_FORMS}/state.tx.us/20110928/coh.pdf", g.instance_variable_get(:@template)
  end
  
  def test02_produce_report_fail_bad_entity
    g = TECFiler::FormGenerator.new(:COH)
    e = assert_raises RuntimeError do
      g.produce_report(Object.new)
    end
    assert_equal "data entity is not a COH", e.message
  end
  
  def test03_produce_report_fail_bad_version
    coh = TECFiler::Model::COH[1]    
    refute_nil coh
    coh.version = "314159"
    g = TECFiler::FormGenerator.new(:COH)
    e = assert_raises RuntimeError do
      g.produce_report(coh)
    end
    assert_equal "form version mismatch (expected 20110928, got 314159)", e.message
  end
  
  def test02_report_coh
    coh = TECFiler::Model::COH[1]
    refute_nil coh
    g = TECFiler::FormGenerator.new(:COH)
    fn = g.produce_report(coh)
    assert_match /\.pdf$/, fn
    assert File.exist?(fn)
    $stderr.puts "Form has been dumped to: #{fn}"
  end  
  
end