require 'simplecov'
class SimpleCov::Formatter::QualityFormatter
  def format(result)
    SimpleCov::Formatter::HTMLFormatter.new.format(result)
    File.open("coverage/covered_percent", "w") do |f|
      f.puts result.source_files.covered_percent.to_f
    end
  end
end

SimpleCov.formatter = SimpleCov::Formatter::QualityFormatter
SimpleCov.start

require "rubygems"
require "bundler/setup"

require "rspec"
require 'json'

raise "can not require tecfiler" unless require_relative('../../lib/tecfiler')
