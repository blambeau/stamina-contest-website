require File.join(File.dirname(__FILE__), '..', 'fixtures')
describe "WebStamina::DatabaseFunctions" do
  include WebStamina::Test::Fixtures
  
  # Lauches Waw
  before(:all) { waw_autoload; install_initial_state }
  after(:all)  { waw_unload }
  
  it 'should provide a tool for getting a single user tuple' do
    db.respond_to?(:user_tuple).should be_true
    db.user_tuple(:mail => "testuser1@stamina.chefbe.net")[:id].should == 1
    db.user_tuple(:id => 1)[:id].should == 1
    db.user_tuple({:mail => "unexisting"}, false).should be_nil
    lambda { db.user_tuple(:mail => "unexisting") }.should raise_error(::WebStamina::NoSuchTuple)
    lambda { db.user_tuple(:activation => "")     }.should raise_error(::WebStamina::UnexpectedCase)
  end
  
  it "should provide a shortcut for testing existence of users" do
    db.user_exists?(:mail => "testuser1@stamina.chefbe.net").should be_true
    db.user_exists?(:nickname => "testuser1").should be_true
    db.user_exists?(:id => 2).should be_true
    db.user_exists?(:id => 100).should be_false
  end
  
end