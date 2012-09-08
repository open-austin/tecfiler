module TECFiler
  class CSVParser
    include Singleton

    ACCEPT_FILING = 'The filing is acceptable.'
    REJECT_FILING_FILENAME_EXTENSION = "The filing is rejected because the filename's extension is not \".csv\""

    def self.parse(filename)
      instance.parse filename
    end

    def self.line_validator(line, n_fields=nil)
      instance.line_validator(line, n_fields)
    end

    def validate_filename_extension(filename)
      raise REJECT_FILING_FILENAME_EXTENSION unless File.extname(filename.downcase) == '.csv'
    end

    def parse(filename)
      begin
        validate_filename_extension(filename)
      rescue Exception => ex
        return ex.to_s
      end
      ACCEPT_FILING
    end

    # a,"b","c",d","e
    # returns nil if valid otherwise error string
    def line_validator(line, n_fields=nil)
      return nil if line =~ /^\s*#/
      errors = []
      values = line.split(',')
      errors << 'first column has a double quote' if values[0] =~ /"/
      errors << 'second column has a double quote' if values[1] =~ /"/
      begin
        values = CSV.parse_line(line, {})
        unless n_fields.nil?
          errors << "Expected #{n_fields} columns but have #{values.size} columns" unless values.size == n_fields
        end
        values.each_index do |index|
          value = values[index]
          unless value.nil?
            v = value.dup
            v = value.sub(/^"(.*)"$/, '\1')  # remove double quotes around value
            v = v.gsub(/","/, ',')  # allow double quoted comma
            errors << 'The value (#{value} in column #{index} has an embedded double quote' if v =~ /"/
          end
        end
      rescue Exception => ex
        errors << ex.to_s
      end
      errors.empty? ? nil : errors.join("\n")
    end
  end
end
