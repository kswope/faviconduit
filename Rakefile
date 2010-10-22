require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    desc = "download a webpage's favicon"
    gem.name = "faviconduit"
    gem.summary = desc
    gem.description = desc
    gem.email = "git-kevdev@snkmail.com"
    gem.homepage = "http://github.com/kswope/faviconduit"
    gem.authors = ["Kevin Swope"]
    gem.add_dependency 'nokogiri'
    gem.add_dependency 'addressable'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

task :default => :test

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end
