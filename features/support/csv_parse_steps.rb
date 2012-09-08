Given /^an empty file with a filename of (\S+)$/ do |arg1|
  @filename = File.expand_path(arg1, '/tmp')
  FileUtils.rm_f @filename
  FileUtils.touch @filename
end

When /^passed to the parser$/ do
  @result = TECFiler::CSVParser.parse(@filename)
end

Then /^the output should contain: (.*)$/ do |arg1|
  @result.should match(arg1)
end
