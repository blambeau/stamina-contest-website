require File.join(File.dirname(__FILE__), '..', 'fixtures')
describe "PeopleController actions" do
  include WebStamina::Test::Fixtures
  
  # Lauches Waw
  before(:all) { waw_autoload; install_initial_state }
  after(:all)  { waw_unload }
  
  it "should provide a secure login action" do
    signature = people_controller.login.signature
    signature.should_not be_nil
    signature.blocks?({}).should be_true
    signature.blocks?(:mail => "testuser1@stamina.chefbe.net", :password => nil).should be_true
    signature.blocks?(:mail => "testuser1@stamina.chefbe.net", :password => "").should be_true
    signature.blocks?(:mail => "unexisting", :password => "password").should be_true
    signature.blocks?(:mail => "testuser1@stamina.chefbe.net", :password => "password").should be_true
    signature.blocks?(:mail => "testuser1@stamina.chefbe.net", :password => "testuser1").should be_false
  end
  
end
