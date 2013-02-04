require 'rake'

task :default => :test

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.verbose = true
  t.libs = %w(test/lib lib)
  t.pattern = "test/src/test*.rb"
end

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : "<unavailable>"
  rdoc.rdoc_dir = "rdoc/html"
  rdoc.title = "TEC Filer version #{version}"
  rdoc.rdoc_files.include("**/*.rdoc")
  rdoc.rdoc_files.include("lib/**/*.rb")
end


# vi:et:ai:ts=2:sw=2
