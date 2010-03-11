module Waw
  class Session

    # Current id (by mail) of the user which is logged
    session_var :user
    
    # Current user
    query_var(:current_user) {|s| 
      s.logged? ? Waw.resources.db.default.people.send(:underlying_table).filter(:mail => s.user).first : {}
    }
    
    # Current user e-mail
    query_var(:user_mail) {|s| s.logged? ? s.current_user[:mail] : ''}
    
    # Is there a cureent user logged?
    query_var(:logged?) {|s| not(s.user.nil?) }
    
  end
end