WLang::file_extension_map('.redcloth', 'wlang/xhtml')
module WebStamina
  
  # Current version of the WebStamina architecture
  VERSION = "0.0.1"
  
end # module WebStamina
require 'waw/tools/mail'
require 'web_stamina/wawext'
require 'web_stamina/tools'
require 'web_stamina/controllers/people_controller'

::Waw::kernel.add_start_hook do |kernel|
  database = ::Rubyrel::connect(kernel.config.database_handler)
  kernel.resources.send(:add_resource, :db, database)
end