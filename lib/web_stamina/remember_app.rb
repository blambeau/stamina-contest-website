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
      if not(session.logged?) and (had_cookie = request.cookies['stamina_ident'])
        begin
          mail, pass = Marshal.load(Base64.decode64(had_cookie))
          session_set(:user, mail) if authorized_user?(mail, pass)
        rescue => ex
        end
      end
      
      # make the delegate call now
      result = @app.call(env)
      res = Rack::Response.new(result[2], result[0], result[1])
      
      # Restore the cookie now
      if session.logged?
        user = session.current_user()
        cookie_value = Base64.encode64(Marshal.dump([user[:mail], user[:password]]))
        res.set_cookie('stamina_ident', cookie_value)
      else
        res.delete_cookie('stamina_ident')
      end
      
      # Send the response now
      res.to_a
    end
    
  end # class RememberApp
end # module WebStamina
  