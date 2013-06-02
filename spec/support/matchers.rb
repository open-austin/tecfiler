
RSpec::Matchers.define :require_attribute do |attribute|
  match do |entity|
    entity.send(:"#{attribute}=", nil)
    ! entity.valid?
  end
end

RSpec::Matchers.define :accept_attribute_value do |attribute, value|
  match do |entity|
    entity.send(:"#{attribute}=", value)
    entity.valid?
  end
end

RSpec::Matchers.define :accept_attribute_length do |attribute, length|
  match do |entity|
    entity.send(:"#{attribute}=", "x" * length)
    entity.valid?
  end
end
