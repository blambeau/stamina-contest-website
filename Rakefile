require "rubygems"
require "rake/rdoctask"
require "rake/testtask"
require 'spec/rake/spectask'
require "waw"

task :default => [:test]

desc "Launches all wspec tests"
task :wspec do
  require('test/wspec/test_all.rb')
end

desc "Run all rspec test"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['test/spec/test_all.rb']
end

desc "Launches all tests"
task :test => [:wspec]