require File.join(File.dirname(__FILE__), '..', 'fixtures')
describe "PeopleController.subscribe action" do
  include WebStamina::Test::Fixtures
  
  # Lauches Waw
  before(:all) { waw_autoload; install_initial_state }
  after(:all)  { waw_unload }
  
  it "should detect already existing users" do
    signature = people_controller.subscribe.signature
    signature.validate(:mail => "testuser1@stamina.chefbe.net")[1].include?(:mail_already_used).should be_true
    signature.validate(:nickname => "testuser1")[1].include?(:nickname_already_used).should be_true
  end

  it "should detect non matching password" do
    signature = people_controller.subscribe.signature
    signature.validate(:password => "p", :password_confirm => "nop")[1].include?(:passwords_dont_match).should be_true
  end
  
end