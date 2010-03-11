module Waw
  module Validation
    
    validator :valid_activation_key, validator{|key| 
      relvar = Waw.resources.db.default.people
      table  = relvar.send(:underlying_table)
      table.filter(:activation => key).count == 1 
    }
    
  end # module Validation
end # module Waw