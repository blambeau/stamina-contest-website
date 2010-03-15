WLang::file_extension_map('.redcloth', 'wlang/xhtml')
module WebStamina
  
  # Current version of the WebStamina architecture
  VERSION = "0.0.1"
  
  # Generates a fake binary sequence
  def generate_fake_binary_sequence
    s = ""
    1500.times{|i| s << kernel.rand(1) }
    s
  end
  module_function :generate_fake_binary_sequence
  
end # module WebStamina
require 'waw/tools/mail'
require 'web_stamina/errors'
require 'web_stamina/database_functions'
require 'web_stamina/wawext'
require 'web_stamina/remember_app'
require 'web_stamina/grid_tools'
require 'web_stamina/controllers/people_controller'
require 'web_stamina/controllers/compete_controller'

::Waw::kernel.add_start_hook do |kernel|
  database = ::Rubyrel::connect(kernel.config.database_handler)
  database.extend(WebStamina::DatabaseFunctions)
  kernel.resources.send(:add_resource, :db, database)
  kernel.resources.send(:add_resource, :sequel_db, database.handler)
  kernel.resources.send(:add_resource, :grid_tools, ::WebStamina::GridTools.new(database))
end