module WebStamina
  module DatabaseFunctions
    
    #
    # Returns a single tuple by applying a filter on the people relation variable. 
    #
    # If no such tuple exists, raises a WebStamina::NoSuchTuple if raise_on_unexisting 
    # is set to true, returns false otherwise.
    #
    # Raises a WebStamina::UnexpectedCase if the filter does not lead to one single
    # tuple.
    #
    def user_tuple(filter, raise_on_unexisting = true)
      tuples = handler[:people].filter(filter).all
      case tuples.size
        when 0
          raise WebStamina::NoSuchTuple, "Unknown user #{filter.inspect}" if raise_on_unexisting
          return nil
        when 1
          return tuples[0]
        else
          raise WebStamina::UnexpectedCase, "Multiple users for #{filter.inspect}"
      end
    end
    
    # Returns a filtered version of the people relation variable.
    def users(filter = {})
      handler[:people].filter(filter)
    end
    
  end # module DatabaseFunctions
end # module WebStamina