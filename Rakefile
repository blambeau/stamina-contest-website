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
task :test => [:spec, :wspec]

desc "Installs the database from scratch"
task :"db-install" do
  require('lib/web_stamina/model/install')
end

desc "Installs the download files"
task :downloads do
  kernel = ::Waw::autoload(__FILE__)
  kernel.resources.db.default.competition_data.each do |tuple|
    File.open("public/downloads/training_sample_#{tuple.problem}.txt", 'w') do |file|
      file << tuple.learning_sample
    end
    File.open("public/downloads/test_sample_#{tuple.problem}.txt", 'w') do |file|
      file << tuple.test_sample
    end
  end
end