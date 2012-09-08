$:.insert(0, "#{File.dirname($0)}/../lib")
require "minitest/autorun"
require "tecfiler"

require "pp"
    
class TestModelReportCOH < MiniTest::Unit::TestCase
  
  def setup
    @a = TECFiler::Model::ReportCOH.new(
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
      :period_end => "2012-03-31"
    )
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
  
  def test_required_fields
    REQUIRED_FIELDS.each {|field| validate_required_field(@a, field)}
  end
  
  
  def test_telno_fields
    TELNO_FIELDS.each {|field| validate_telno_field(@a, field)}
  end  

  
  
end

# vi:et:ai:ts=2:sw=2