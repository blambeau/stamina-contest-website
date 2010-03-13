module Waw
  module Validation
    
    #############################################################################################
    # Validators for subscription
    #############################################################################################
    
    # Checks that a validation key is valid
    validator :valid_activation_key, validator{|key| 
      Waw.resources.sequel_db[:people].filter(:activation => key).count == 1 
    }
    
    # Checks that a mail is not alredy in use
    validator :mail_not_in_use, validator{|mail|
      Waw.resources.sequel_db[:people].filter(:mail => mail).empty?
    }
    
    # Checks that a nick name is not already in use
    validator :nickname_not_in_use, validator{|nickname|
      Waw.resources.sequel_db[:people].filter(:nickname => nickname).empty?
    }
    


    #############################################################################################
    # Validators about user login
    #############################################################################################
    
    # Checks that a given user is allowed to log in
    validator :authorized_user, validator{|mail, password|
      tuple = Waw.resources.sequel_db[:people].filter(
        :mail => mail, 
        :password => Digest::MD5.hexdigest(password), 
        :activation => ""
      ).first
      tuple && (tuple[:admin_level] >= 0)
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
    
    # Checks that a cell file has a valid format
    validator :valid_cellfile, WebStamina::CellFileValidator.new
    
  end # module Validation
end # module Waw