require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "ruby_sugar"
    gem.summary = %Q{Ruby wrapper for the SugarCRM API}
    gem.description = %Q{Ruby wrapper for the SugarCRM API}
    gem.email = "dennijo@gmail.com"
    gem.homepage = "http://github.com/dennijo/ruby_sugar"
    gem.authors = ["Josh Dennis"]
    gem.files   = FileList["[A-Z]*", "{lib,test}/**/*"]    

  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.ruby_opts << '-rubygems'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ruby_sugar #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
