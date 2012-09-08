require 'rake/testtask'
Rake::TestTask.new do |t|
  t.verbose = true
end

require 'rdoc/task'
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = "doc/html"
  rdoc.rdoc_files.include("lib/**/*.rb")
end

# vi:et:ai:ts=2:sw=2
