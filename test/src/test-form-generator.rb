cwd = File.dirname(__FILE__)
$:.insert(0, "#{cwd}/../lib", "#{cwd}/../../lib")
require "minitest/autorun"
require "tecfiler"
require "test-support"
    
class TestFormGenerator< MiniTest::Unit::TestCase
  
  # XXX - This is depending on other tests having run and created database.
  # Would be better if we create some mock data structures and use that.
  
  def test02_produce_fail_bad_entity
    e = assert_raises RuntimeError do
      TECFiler::FormGenerator::produce(Object.new)
    end
    assert_equal "do not know how to produce form for entity type Object", e.message
  end
  
  def test03_produce_fail_bad_version
    coh = TECFiler::Model::COH.new
    refute_nil coh
    e = assert_raises RuntimeError do
      TECFiler::FormGenerator::produce(coh, :version => "314159")
    end
    assert_equal "form template not found: /home/chip/Workspace/tecfiler/lib/tecfiler/forms/state.tx.us/314159/coh.pdf", e.message
  end
  
  def test10_report_coh
    coh = TECFiler::Model::COH.new(TECFiler::Test::PARAMS_COH)
    fn = TECFiler::FormGenerator::produce(coh)
    $stderr.puts "Form has been dumped to: #{fn}"
  end  
  
end