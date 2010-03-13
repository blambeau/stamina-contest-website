require 'base64'
module WebStamina
  class RememberApp
    include Waw::EnvironmentUtils
    include ::Rack::Delegator
    
    # Creates a application instance
    def initialize(app)
      @app = app
    end
    
    # Manage calls
    def call(env)
      # autolog the user if needed
      remember_me = request.cookies['remember_me']
      if not(session.logged?) and (remember_me) and not(remember_me.empty?)
        user = Waw.resources.sequel_db[:people].filter(:remember_me => remember_me).first
        if user
          session_set(:user, user[:mail]) 
          Waw.logger.debug("Autologging user #{user[:nickname]}")
        end
      end
      
      # make the delegate call now
      result = @app.call(env)
      res = Rack::Response.new(result[2], result[0], result[1])
      
      # Restore the cookie now
      current_user = session.current_user
      if current_user[:id] and not(remember_me == current_user[:remember_me])
        Waw.logger.debug("Setting new remember_me cookie for user #{current_user[:nickname]}")
        res.set_cookie('remember_me', current_user[:remember_me])
      elsif current_user[:id].nil?
        Waw.logger.debug("Unsetting remember_me cookie")
        res.delete_cookie('remember_me')
      end
      
      # Send the response now
      res.to_a
    end
    
  end # class RememberApp
end # module WebStamina
  