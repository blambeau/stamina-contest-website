require "rubygems"
require "rake/rdoctask"
require "rake/testtask"
require "rspec/core/rake_task"
require "waw"
require "fileutils"

task :default => [:test]

desc "Launches all wspec tests"
task :wspec do
  require('test/wspec/test_all.rb')
end

desc "Run RSpec code examples"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'test/spec/test_all.rb'
end

desc "Launches all tests"
task :test => [:spec, :wspec]

desc "Installs the database from scratch"
task :"db-install" do
  require('lib/web_stamina/model/install')
end

desc "Installs the download files"
task :makegrid do
  kernel = ::Waw::autoload(__FILE__)
  FileUtils.rm_rf("public/downloads/grid") if File.exists?("public/downloads/grid")
  FileUtils.rm_rf("public/downloads/grid.tar.gz") if File.exists?("public/downloads/grid.tar.gz")
  FileUtils.mkdir("public/downloads/grid")
  kernel.resources.db.default.competition_data.each do |tuple|
    File.open("public/downloads/grid/#{tuple.problem}_training.txt", 'w') do |file|
      file << tuple.learning_sample
    end
    File.open("public/downloads/grid/#{tuple.problem}_test.txt", 'w') do |file|
      file << tuple.test_sample
    end
  end
  puts `cd public/downloads && tar -cf grid.tar grid && gzip grid.tar && cd ../..`
end