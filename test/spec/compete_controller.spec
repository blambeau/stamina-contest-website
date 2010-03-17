require File.join(File.dirname(__FILE__), '..', 'fixtures')
describe "CompeteController actions" do
  include WebStamina::Test::Fixtures
  
  # Lauches Waw
  before(:all) { waw_autoload; install_initial_state }
  after(:all)  { waw_unload }
  
  
end
