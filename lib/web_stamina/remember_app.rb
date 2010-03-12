require 'base64'
module WebStamina
  class RememberApp
    include Waw::EnvironmentUtils
    include ::Rack::Delegator
    
    # Creates a application instance
    def initialize(app)
      @app = app
    end
    
    # Is a pair (mail, pass) authorized?
    def authorized_user?(mail, pass)
      tuple = Waw.resources.sequel_db[:people].filter(:mail => mail, :password => pass, :activation => "").first
      tuple && (tuple[:admin_level] >= 0)
    end
    
    # Manage calls
    def call(env)
      # autolog the user if needed
      remember_me = request.cookies['remember_me']
      if not(session.logged?) and (remember_me)
        if not(remember_me.empty?)
          mail = (Waw.resources.sequel_db[:people].filter(:remember_me => remember_me).first || {})[:mail]
        end
        session_set(:user, mail) 
      end
      
      # make the delegate call now
      result = @app.call(env)
      res = Rack::Response.new(result[2], result[0], result[1])
      
      # Restore the cookie now
      if session.logged?
        res.set_cookie('remember_me', session.current_user[:remember_me])
      else
        res.delete_cookie('remember_me')
      end
      
      # Send the response now
      res.to_a
    end
    
  end # class RememberApp
end # module WebStamina
  