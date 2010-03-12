WLang::file_extension_map('.redcloth', 'wlang/xhtml')
module WebStamina
  
  # Current version of the WebStamina architecture
  VERSION = "0.0.1"
  
end # module WebStamina
require 'waw/tools/mail'
require 'web_stamina/wawext'
require 'web_stamina/grid_tools'
require 'web_stamina/controllers/people_controller'
require 'web_stamina/controllers/compete_controller'

::Waw::kernel.add_start_hook do |kernel|
  database = ::Rubyrel::connect(kernel.config.database_handler)
  kernel.resources.send(:add_resource, :db, database)
  kernel.resources.send(:add_resource, :sequel_db, database.handler)
  kernel.resources.send(:add_resource, :grid_tools, ::WebStamina::GridTools.new(database))
end