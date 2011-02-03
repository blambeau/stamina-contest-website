#!/usr/bin/env rackup
require "rubygems"
begin
  require "bundler/setup"
  require "waw"
rescue LoadError => ex
  gem "waw", "~> 0.3.0"
  require "waw"
end
run Waw.autoload(__FILE__)
