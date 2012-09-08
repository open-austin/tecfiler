require "data_mapper"

# If you want the logs displayed you have to do this before the call to setup
DataMapper::Logger.new($stderr, :debug)

# An in-memory Sqlite3 connection:
DataMapper.setup(:default, 'sqlite::memory:')

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

# vi:et:ai:ts=2:sw=2