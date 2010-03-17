module Waw
  module Validation
    
    #############################################################################################
    # Validators for subscription
    #############################################################################################
    
    # Checks that a validation key is valid
    validator :valid_activation_key, validator{|key| 
      Waw.resources.db.user_exists?(:activation => key)
    }
    
    # Checks that a mail is not alredy in use
    validator :mail_not_in_use, validator{|mail|
      not(Waw.resources.db.user_exists?(:mail => mail))
    }
    
    # Checks that a nick name is not already in use
    validator :nickname_not_in_use, validator{|nickname|
      not(Waw.resources.db.user_exists?(:nickname => nickname))
    }
    


    #############################################################################################
    # Validators about user login
    #############################################################################################
    
    # Checks that a given user is allowed to log in
    validator :authorized_user, validator{|mail, password|
      user = Waw.resources.db.user_tuple(
        {:mail      => mail, 
         :password   => Digest::MD5.hexdigest(password.nil? ? "" : password), 
         :activation => ""}, false)
      user && (user[:admin_level] >= 0)
    }
    
    # Checks that the user is currently logged
    validator :logged, validator{|mail| Waw.session.logged? }
    


    #############################################################################################
    # Validators about challenger names
    #############################################################################################
    
    # Checks that an algorithm name respects [0-9a-zA-Z_\-]{2,10}
    validator :valid_algorithm_name, validator{|algorithm|
      (algorithm =~ /^[0-9a-zA-Z\-_]{2,10}$/)
    }
    
    # Checks that an algorithm name is not already in use
    validator :algorithm_not_in_use, validator{|algorithm|
      Waw.resources.sequel_db[:challengers].
          filter(:people => Waw.session.user_id, :algorithm => algorithm).
          empty?
    }


    
    #############################################################################################
    # Validators about submissions
    #############################################################################################
    
    # Checks that the current user may submit for a given algorithm 
    validator :valid_algorithm_for_submission, validator{|algorithm|
      not(Waw.resources.sequel_db[:challengers].
              filter(:people => Waw.session.user_id, :algorithm => algorithm).
              empty?)
    }
    
    # Checks that a binary sequence is valid
    validator :valid_binary_sequence, validator{|binseq|
      binseq.to_s =~ /^[01]{1500}$/
    }
    validator :valid_binary_sequences, validator{|binseq|
      ::Array===binseq and binseq.all?{|s| s.to_s =~ /^[01]{1500}$/}
    }
    
    # Checks that a cell file has a valid format
    validator :valid_cellfile, WebStamina::CellFileValidator.new
    
  end # module Validation
end # module Waw