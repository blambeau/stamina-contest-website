module Waw
  module Validation
    
    validator :valid_activation_key, validator{|key| 
      relvar = Waw.resources.db.default.people
      table  = relvar.send(:underlying_table)
      table.filter(:activation => key).count == 1 
    }
    
    validator :authorized_user, validator{|mail, password|
      password = Digest::MD5.hexdigest(password)
      relvar = Waw.resources.db.default.people
      table  = relvar.send(:underlying_table)
      tuple = table.filter(:mail => mail, :password => password, :activation => "").first
      tuple && (tuple[:admin_level] >= 0)
    }
    
  end # module Validation
end # module Waw