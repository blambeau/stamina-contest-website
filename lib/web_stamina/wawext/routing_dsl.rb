module Waw
  module Routing
    # The DSL for routing blocks
    class DSL 
      
      def popup_message(message)
        Waw::Routing::PopupMessage.new(message)
      end
      
      def submission_feedback
        Waw::Routing::SubmissionFeedback.new
      end
      
    end # class DSL
  end # module Routing
end # module Waw
