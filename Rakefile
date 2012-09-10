require 'rake/testtask'
Rake::TestTask.new do |t|
  t.verbose = true
end

require 'rake'

begin
  require 'rspec/core'
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |spec|
    spec.pattern = FileList['spec/**/*_spec.rb']
  end

  RSpec::Core::RakeTask.new(:rcov) do |spec|
    spec.pattern = 'spec/**/*_spec.rb'
    spec.rcov = true
  end
rescue LoadError
  warn "rspec not available, spec task not provided."
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)
rescue LoadError
  warn "cucumber not available, features task not provided."
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : "<unavailable>"
  rdoc.rdoc_dir = 'rdoc/html'
  rdoc.title = "TEC Filer version #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'redcarpet'
  require 'pygments.rb'

  class HTMLwithPygments < Redcarpet::Render::XHTML
    def doc_header()
      '<style>' + Pygments.css('.highlight',:style => 'friendly') + '</style>'
    end
    def block_code(code, language)
      Pygments.highlight(code, :lexer => language.to_sym, :options => {
          :encoding => 'utf-8'
      })
    end
  end


  def markdown(text)
    renderer = HTMLwithPygments.new(:hard_wrap => true)
    options = {
        :fenced_code_blocks => true,
        :no_intra_emphasis => true,
        :autolink => true,
        :strikethrough => true,
        :lax_html_blocks => true,
        :superscript => true
    }
    Redcarpet::Markdown.new(renderer, options).render(text)
  end

  desc 'Create documents from markdown'
  task :doc do
    Dir['**/*.md'].each do |fn|
      FileUtils.makedirs('doc')
      output_file = File.expand_path(fn.gsub(/\.md$/, '.html'), 'doc')
      File.open(output_file, 'w') {|f| f.puts markdown(IO.read(fn))}
    end
  end
rescue LoadError
  warn "redcarpet or pygments.rb not available, doc task not provided."
end

begin
  require 'cane/rake_task'

  desc "Run cane to check quality metrics"
  Cane::RakeTask.new(:quality) do |cane|
    cane.abc_glob = "{controller,model,spec}/**/*.rb"
    cane.abc_max = 10
    cane.add_threshold 'coverage/covered_percent', :>=, 90
    cane.no_style = false
    cane.doc_glob = "{controller,model}/**/*.rb"
    cane.style_glob = "{controller,model}/**/*.rb"
    #cane.abc_exclude = %w(Foo::Bar.some_method)
  end

rescue LoadError
  warn "cane not available, quality task not provided."
end


# vi:et:ai:ts=2:sw=2
