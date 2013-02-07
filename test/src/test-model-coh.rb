TECFILER_MODE = :TEST
cwd = File.dirname(__FILE__)
$:.insert(0, "#{cwd}/../lib", "#{cwd}/../../lib")
require "minitest/autorun"
require "tecfiler"
require "test-support"
    
class TestModelCOH < MiniTest::Unit::TestCase
  
  def setup
    TECFiler::initialize(:TEST)
      
    @params = TECFiler::Test::load_datafile("sample_coh.json")    
    @a = TECFiler::Model::COH.new(@params)
    assert @a.valid?, "precondition failed: #{@a.errors.to_h}"
  end
  
  # Validation should fail if these fields are nil or empty.
  REQUIRED_FIELDS = [
    :coh_name_first,
    :coh_name_last,
    :coh_address_street,
    :coh_address_city,
    :coh_address_state,
    :coh_address_zip,
    :coh_phone,
    :treasurer_name_first,
    :treasurer_name_last,
    :treasurer_address_street,
    :treasurer_address_city,
    :treasurer_address_state,
    :treasurer_address_zip,
    :treasurer_phone,
    :period_begin,
    :period_end,
  ] 
  
  # These fields should be validated as phone numbers.
  TELNO_FIELDS = [:coh_phone, :treasurer_phone]
  
  
  def validate_required_field(obj, field, empty_value = "") 
    assert obj.valid?, "precondition failed: #{obj.errors.to_h}"  
    saved_value = obj[field]
    obj[field] = nil
    refute obj.valid?, "should not be valid when \"#{field}\" is nil"
    obj[field] = empty_value
    refute obj.valid?, "should not be valid when \"#{field}\" is empty"
    obj[field] = saved_value
    assert obj.valid?, "postcondition failed: #{obj.errors.to_h}"  
  end

  # These are valid telno values.
  TELNO_VALUES_VALID = ["512-555-1212", "512-555-1212x3309", "555-1212"]

  # These are invalid telno values.
  TELNO_VALUES_INVALID = ["5551212", "512-555-1212x"]

  def validate_telno_field(obj, field) 
    TELNO_VALUES_VALID.each do |value|
      assert obj.valid?, "precondition failed: #{obj.errors.to_h}"  
      saved_value = obj[field]
      obj[field] = value
      assert obj.valid?, "field \"#{field}\" value \"#{value}\" should be valid: #{obj.errors.to_h}"
      obj[field] = saved_value
      assert obj.valid?, "postcondition failed: #{obj.errors.to_h}"  
    end

    TELNO_VALUES_INVALID.each do |value|
      assert obj.valid?, "precondition failed: #{obj.errors.to_h}"  
      saved_value = obj[field]
      obj[field] = value
      refute obj.valid?, "field \"#{field}\" value \"#{value}\" should be invalid"
      obj[field] = saved_value
      assert obj.valid?, "postcondition failed: #{obj.errors.to_h}"  
    end
  end
  
  def test_fields_required
    REQUIRED_FIELDS.each {|field| validate_required_field(@a, field)}
  end
  
  
  def test_fields_telno
    TELNO_FIELDS.each {|field| validate_telno_field(@a, field)}
  end
  
  def test_coh_address
    assert_equal ["100 Congress Ave", "Austin, TX 78701"], @a.coh_address
    @a.coh_address_suite = "123"
    assert_equal ["100 Congress Ave ste 123", "Austin, TX 78701"], @a.coh_address
  end  
  
  def test_treasurer_address
    assert_equal ["100 Congress Ave", "Austin, TX 78701"], @a.treasurer_address
    @a.treasurer_address_suite = "123"
    assert_equal ["100 Congress Ave ste 123", "Austin, TX 78701"], @a.treasurer_address
  end  
  
end

# vi:et:ai:ts=2:sw=2