require "data_mapper"

class NilClass
  # So obj.empty? works when obj is expected by hold a String value, but is currently unset.
  def empty?
    true
  end
end

# Require all the ruby files in the tecfiler subdirectory
Dir["#{File.dirname(__FILE__)}/tecfiler/**/*.rb"].each {|fn| require fn}

module TECFiler     
  
  def self.initialize(environment = :PRODUCTION)
    
    case environment
    when :DEVELOPMENT
      db_file = "tecfiler.db"
      log_output = $stderr
    when :TEST
      db_file = "/tmp/tecfiler-test.db"
#      begin
#        File.unlink(db_file)
#      rescue Errno::ENOENT
#        # ignore
#      end
      log_output = "/tmp/tecfiler-db.log"
    when :PRODUCTION
      db_file = "#{File.dirname(__FILE__)}/../data/tecfiler.db"
      log_output = nil
    else
      raise "bad TECFiler mode setting: #{@@mode}"    
    end
    
    # Logging must be initialized before call to setup
    if log_output
      $stderr.puts("Database logging enabled to #{log_output}")
      DataMapper::Logger.new(log_output, :debug)
    end
    
    # Connect to SQLite database in current directory.
    DataMapper.setup(:default, "sqlite3://#{db_file}")
    
    ## XXX - This may not be a good thing to do. The semantics of new().save() are not
    ## quite the same as create(). Plus, we need to do error checking anyway to gather
    ## and display the validation errors, so this may not gain anything (so long as we
    ## are sure to check all return results from database operations.
    ##
    #DataMapper::Model.raise_on_save_failure = true
    
    DataMapper::Validations::FormatValidator::FORMATS.merge!({
      :telno => [/(^$)|(^(\d\d\d-)?\d\d\d-\d\d\d\d(x\d+)?$)/,
        lambda {|field, value| '%s is not a valid phone number (e.g. "512-555-1234x200")'.t(value)}],
      :state_code =>[/(^$)|(^[A-Z][A-Z]$)/,
        lambda {|field, value| '%s is not a valid two-letter state code'.t(value)}],
      :zip_code => [/(^$)|(^\d\d\d\d\d(-\d\d\d\d)?$)/,
        lambda {|field, value| '%s is not a valid zip code (e.g. "99999" or "99999-9999")'.t(value)}],
    })
    
    DataMapper.finalize
    
    # Execute the database operations to make the schema match the model. This will
    # automatically initialize a new database from scatch when needed. It will create
    # new tables and add columns to existing tables as needed. It won't change any
    # existing columns (say, to add a NOT NULL constraint) and it won't drop any columns.
    #
    DataMapper.auto_upgrade!
    
  end
  
end

# vi:et:ai:ts=2:sw=2
