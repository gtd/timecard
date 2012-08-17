require 'jeweler'

Jeweler::Tasks.new do |gem|
  gem.name = "timecard"
  gem.homepage = "http://github.com/gtd/timecard"
  gem.license = "MIT"
  gem.summary = "Simple CLI time tracker"
  gem.description = "Simple UNIX shell time tracker"
  gem.email = "gabe@websaviour.com"
  gem.authors = ["Gabe da Silveira"]

  gem.bindir = 'bin'

  gem.add_development_dependency "rspec", "~> 2.3.0"
  gem.add_development_dependency "jeweler", "~> 1.6.3"
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "timecard #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
