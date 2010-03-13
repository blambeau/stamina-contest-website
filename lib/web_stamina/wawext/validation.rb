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
    
    validator :mail_not_in_use, validator{|mail|
      Waw.resources.sequel_db[:people].filter(:mail => mail).empty?
    }
    
    validator :nickname_not_in_use, validator{|nickname|
      Waw.resources.sequel_db[:people].filter(:nickname => nickname).empty?
    }
    
    validator :valid_cellfile, WebStamina::CellFileValidator.new
    
  end # module Validation
end # module Waw