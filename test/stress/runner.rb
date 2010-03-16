# Starts waw
require 'rubygems'
gem 'waw', '>= 0.2.2'
require 'waw'
require 'waw/wspec'
kernel = ::Waw::autoload(__FILE__)

# Get the commons
require File.join(File.dirname(__FILE__), 'commons')
require File.join(File.dirname(__FILE__), 'competitor')

$solutions = kernel.resources.sequel_db[:competition_data].order(:problem.asc).collect{|t|
  t[:binary_sequence]
}

# Create competitors 
url = "http://127.0.0.1:9292/"
nb_competitors = 10
competitors = []
nb_competitors.times do |i|
  competitors << ::WebStamina::StressTest::Competitor.new(kernel, i+1, url)
end

# Starts them
threads = competitors.collect do |c|
  Thread.new(c) {|c|
    c.run
  }
end
threads.each{|t| t.join}