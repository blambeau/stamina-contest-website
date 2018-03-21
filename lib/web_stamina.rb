WLang::file_extension_map('.redcloth', 'wlang/xhtml')
module WebStamina
  
  # Current version of the WebStamina architecture
  VERSION = "0.0.2"
  
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
require 'web_stamina/no_cache'
require 'web_stamina/grid_tools'
require 'web_stamina/controllers/people_controller'
require 'web_stamina/controllers/compete_controller'
