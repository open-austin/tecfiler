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

Given /^a single line filing: (.*)$/ do |arg1|
  @line = arg1
end


Given /^the number of required fields: (\d+)$/ do |arg1|
  @n_fields = arg1.to_i
end


When /^passed to the line validator$/ do
  @result = TECFiler::CSVParser.line_validator(@line, @n_fields)
end

Then /^the output should be: (.*)$/ do |arg1|
  case arg1
    when 'valid'
      @result.should be_nil
    when 'invalid'
      @result.should_not be_nil
  end
end
