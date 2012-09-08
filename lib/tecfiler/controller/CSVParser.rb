module TECFiler
  class CSVParser
    include Singleton

    ACCEPT_FILING = 'The filing is acceptable.'
    REJECT_FILING_FILENAME_EXTENSION = "The filing is rejected because the filename's extension is not \".csv\""

    def self.parse(filename)
      instance.parse filename
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
  end
end
