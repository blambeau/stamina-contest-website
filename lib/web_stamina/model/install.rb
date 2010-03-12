require 'rubygems'
require 'rubyrel'
require 'rubyrel/commands/command'
require 'rubyrel/commands/create'
require 'rubyrel/commands/rel'

handler = 'postgres://stamina:stamina@localhost/stamina'
def relative_file(file)
  File.expand_path(File.join(File.dirname(__FILE__), file))
end

create = Rubyrel::Commands::Create.new
create.run(__FILE__, ['-h', handler, '--trace', '--verbose', relative_file('stamina.rel')])
db = Sequel::connect(handler)
db << File.read(relative_file('stamina.ext'))

rel = Rubyrel::Commands::Rel.new
rel.run(__FILE__, ['-h', handler, '--trace', '--verbose', '-f', relative_file('stamina.data')])
#rel.run(__FILE__, ['-h', handler, '--trace', '--verbose', '-f', relative_file('test.data')])