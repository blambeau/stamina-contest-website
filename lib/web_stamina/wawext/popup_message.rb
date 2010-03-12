module Waw
  module Routing
    # PopupMessage routing
    class PopupMessage < RoutingRule

      # Creates a feedback instance
      def initialize(message)
        @message = message
      end

      def generate_js_code(result, align=0)
        buffer = "show_popup('/messages/#{@message}');"
        buffer
      end
      
    end # class Feedback
  end # module Routing
end # module Waw