require File.join(File.dirname(__FILE__), '..', 'fixtures')
describe "PeopleController.login action" do
  include WebStamina::Test::Fixtures
  
  # Lauches Waw
  before(:all) { waw_autoload; install_initial_state }
  after(:all)  { waw_unload }
  
  it "should block invalid requests" do
    signature = people_controller.login.signature
    signature.blocks?({}).should be_true
    signature.blocks?(:mail => "testuser1@stamina.chefbe.net", :password => nil).should be_true
    signature.blocks?(:mail => "testuser1@stamina.chefbe.net", :password => "").should be_true
    signature.blocks?(:mail => "unexisting", :password => "password").should be_true
    signature.blocks?(:mail => "testuser1@stamina.chefbe.net", :password => "password").should be_true
  end
  
  it "should allows valid requests" do
    signature = people_controller.login.signature
    signature.allows?(:mail => "testuser1@stamina.chefbe.net", :password => "testuser1").should be_true
  end
  
end
