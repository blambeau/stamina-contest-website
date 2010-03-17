module WebStamina
  module Test
    module Fixtures
      
      # Autoloads waw and returns the kernel application
      def waw_autoload
        require 'rubygems'
        require 'waw'
        @kernel = ::Waw::autoload(__FILE__)
      end
      module_function :waw_autoload
      
      # Returns the kernel application
      def kernel
        @kernel
      end
      module_function :kernel
      
      # Returns the database
      def db 
        @kernel.resources.db
      end
      module_function :db
      
      # Unloads waw
      def waw_unload
        @kernel.unload
        Waw::KERNELS.clear
      end
    
      # Returns the tuple for user #i
      def user_tuple(i, encrypt_pass = false)
        {:id => i, 
         :mail => "testuser#{i}@stamina.chefbe.net", 
         :nickname => "testuser#{i}", 
         :password => encrypt_pass ? md5("testuser#{i}") : "testuser#{i}", 
         :admin_level => 0, 
         :activation => ""}
      end
      module_function :user_tuple
    
      # Returns a challenger tuple
      def challenger_tuple(i)
        {:people => i, :algorithm => "chal#{i}", :creation_time => Time.now}
      end
      module_function :challenger_tuple
    
      # Encodes a password
      def md5(pass)
        Digest::MD5.hexdigest(pass)
      end
      module_function :md5
    
      # Generates a random binary sequence
      def randbinary(problem)
        s = ""; 1500.times{|i| s << rand(2).to_s }; s
      end
      module_function :randbinary
      
      # Installs the initial state on the kernel
      def install_initial_state
        db = kernel.resources.db
        db.default.submissions = []
        db.default.valid_submissions = []
        db.default.challengers = []
        db.default.people = (1..5).collect{|i| user_tuple(i, true) }
        db.default.challengers = (1..5).collect{|i| challenger_tuple(i) }
      end
      module_function :install_initial_state
      
      # Returns the people controller
      def people_controller
        @kernel.resources.controllers.people
      end
    
      # Returns the compete controller
      def compete_controller
        @kernel.resources.controllers.compete
      end
    
    end # module Fixtures
  end # module Test
end # module WebStamina