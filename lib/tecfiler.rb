require "data_mapper"

# If you want the logs displayed you have to do this before the call to setup
DataMapper::Logger.new($stderr, :debug)

# An in-memory Sqlite3 connection:
#DataMapper.setup(:default, 'sqlite::memory:')
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/tecfiler.db")

DataMapper::Model.raise_on_save_failure = true

DataMapper::Validations::FormatValidator::FORMATS.merge!(
  :telno => [
    /(^$)|(^(\d\d\d-)?\d\d\d-\d\d\d\d(x\d+)?$)/i,
    lambda { |field, value|
      '%s is not a valid phone number (e.g. 512-555-1234x200)'.t(value)
    }
  ]
)

require "tecfiler/model/report_coh"
require "tecfiler/model/coh_contribution"

DataMapper.finalize


# DataMapper.auto_migrate!

# This will issue the necessary CREATE statements (DROPing the table first, if it exists) to define each storage
# according to their properties. After auto_migrate! has been run, the database should be in a pristine state.
# All the tables will be empty and match the model definitions.

# This wipes out existing data, so you could also do:

DataMapper.auto_upgrade!

# This tries to make the schema match the model. It will CREATE new tables, and add columns to existing tables.
# It won't change any existing columns though (say, to add a NOT NULL constraint) and it doesn't drop any columns.
# Both these commands also can be used on an individual model (e.g. Post.auto_migrate!)

require 'singleton'

# require all the ruby files in the tecfiler subdirectory
Dir["#{File.dirname(__FILE__)}/**/*.rb"].each {|fn| require_relative fn}

# vi:et:ai:ts=2:sw=2