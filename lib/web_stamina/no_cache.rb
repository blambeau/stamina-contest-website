module WebStamina
  class NoCache
    include Waw::EnvironmentUtils
    include ::Rack::Delegator
    
    NO_CACHE_HEADERS = {'Cache-control' => "no-store, no-cache, must-revalidate", 
                        'Pragma'        => "no-cache", 
                        'Expires'       => "Thu, 01 Dec 1994 16:00:00 GMT"}
    
    # Creates a application instance
    def initialize(app)
      @app = app
    end
    
    # Manage calls
    def call(env)
      triple = @app.call(env)
      headers = triple[1]
      headers.merge!(NO_CACHE_HEADERS)
      triple
    end
    
  end # class NoCache
end # module WebStamina