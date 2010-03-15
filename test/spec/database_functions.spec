require 'rubygems'
require 'waw'
::Waw::autoload(__FILE__)

describe ::WebStamina::DatabaseFunctions do
  
  before(:all) {
    @db = Waw.resources.db
    @db.default.submissions = []
    @db.default.valid_submissions = []
    @db.default.challengers = []
    @db.default.people = [
      {:id          => 1, 
       :mail        => "blambeau@gmail.com", 
       :nickname    => 'blambeau', 
       :password    => Digest::MD5.hexdigest('password'), 
       :activation  => '',
       :admin_level => 0},
      {:id          => 2, 
       :mail        => "damaschristophe@gmail.com", 
       :nickname    => 'damas', 
       :password    => Digest::MD5.hexdigest('password'), 
       :activation  => '',
       :admin_level => 0}
    ]
  }
  
  it 'should provide a tool for getting a single user tuple' do
    @db.respond_to?(:user_tuple).should be_true
    @db.user_tuple(:mail => "blambeau@gmail.com")[:id].should == 1
    @db.user_tuple(:id => 1)[:id].should == 1
    @db.user_tuple({:mail => "unexisting"}, false).should be_nil
    lambda { @db.user_tuple(:mail => "unexisting") }.should raise_error(::WebStamina::NoSuchTuple)
    lambda { @db.user_tuple(:activation => "")     }.should raise_error(::WebStamina::UnexpectedCase)
  end
  
  it "should provide a shortcut for testing existence of users" do
    @db.user_exists?(:mail => "blambeau@gmail.com").should be_true
    @db.user_exists?(:nickname => "blambeau").should be_true
    @db.user_exists?(:id => 2).should be_true
    @db.user_exists?(:id => 100).should be_false
  end
  
end