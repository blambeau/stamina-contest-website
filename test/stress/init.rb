# Starts waw
require 'rubygems'
gem 'waw', '>= 0.2.2'
require 'waw'
::Waw::autoload(__FILE__)

# Get the commons
require File.join(File.dirname(__FILE__), 'commons')

# Sets the initial database state
db = Waw.resources.db
db.default.submissions = []
db.default.valid_submissions = []
db.default.challengers = []
db.default.people      = (1..100).collect{|i| ::WebStamina::StressTest::Commons.user_tuple(i, true) }
db.default.challengers = (1..100).collect{|i| ::WebStamina::StressTest::Commons.challenger_tuple(i) }
