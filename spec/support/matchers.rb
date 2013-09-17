# example: @entity.should validate
RSpec::Matchers.define :validate do
  match do |entity|
    ok = entity.valid? && entity.errors.empty?
    @a = entity.errors.messages.to_s
    ok
  end
  failure_message_for_should do |entity|
    "The given \"#{entity.class}\" should be valid, but was rejected because: #{@a}"    
  end
  failure_message_for_should_not do |entity|
    "The given \"#{entity.class}\" should not be valid, but was accepted"
  end
end

# example: @entity.should require_attribute(:name)
RSpec::Matchers.define :require_attribute do |attribute|
  match do |entity|
    raise "precondition failed, entity invalid: #{entity.errors.messages.to_s}" unless entity.valid?
    entity.send(:"#{attribute}=", nil)
    ! entity.valid? && entity.errors.messages.include?(attribute)
  end
  failure_message_for_should do |entity|
    "#{entity.class} attribute \"#{attribute}\" should be required, but undefined value is accepted"
  end
  failure_message_for_should_not do |entity|
    "#{entity.class} attribute \"#{attribute}\" should not be required, but undefined value is rejected"
  end
  description do |entity|
    "require attribute \"#{attribute}\" value be defined"
  end
end

# example: @entity.should accept_attribute_value(:name, "Joe")
RSpec::Matchers.define :accept_attribute_value do |attribute, value|
  match do |entity|
    raise "precondition failed, entity invalid: #{entity.errors.messages.to_s}" unless entity.valid?
    entity.send(:"#{attribute}=", value)
    entity.valid? && entity.errors.empty?
  end
  failure_message_for_should do |entity|
    "#{entity.class} should accept attribute \"#{attribute}\" value \"#{value}\", but it is rejected"
  end
  failure_message_for_should_not do |entity|
    "#{entity.class} should reject attribute \"#{attribute}\" value \"#{value}\", but it is accepted"
  end
  description do |entity|
    "accept attribute \"#{attribute}\" value \"#{value}\""
  end
end

# example: @entity.should accept_attribute_length(:name, 45)
RSpec::Matchers.define :accept_attribute_length do |attribute, length|
  match do |entity|
    raise "precondition failed, entity invalid: #{entity.errors.messages.to_s}" unless entity.valid?
    entity.send(:"#{attribute}=", "x" * length)
    entity.valid? && entity.errors.empty?
  end
  failure_message_for_should do |entity|
    "#{entity.class} should accept an attribute \"#{attribute}\" value of length \"#{length}\", but it is rejected"
  end
  failure_message_for_should_not do |entity|
    "#{entity.class} should reject an attribute \"#{attribute}\" value of length \"#{length}\", but it is accepted"
  end
  description do |entity|
    "accept attribute \"#{attribute}\" value of length \"#{length}\""
  end
end
