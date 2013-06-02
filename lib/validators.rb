class BlankValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.blank?
      record.errors[attribute] << (options[:message] || "is not blank")
    end
  end
end