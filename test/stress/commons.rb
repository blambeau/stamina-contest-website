module WebStamina
  module StressTest
    module Commons
      
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
        if Kernel.rand(100)<=10
          $solutions[problem-1]
        else
          s = ""; 1500.times{|i| s << rand(2).to_s }; s
        end
      end
      module_function :randbinary

    end # module Commons
  end # module StressTest
end # module WebStamina