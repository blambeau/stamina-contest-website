module Waw
  module Routing
    class SubmissionFeedback < RoutingRule

      def generate_js_code(result, align=0)
        <<-EOF
          show_popup('/messages/' + data[1][0], function(){
            $('#popup .scores').html("Exact BCR score(s): " + data[1][1].join(', '));
          });
        EOF
      end
      
    end # class Feedback
  end # module Routing
end # module Waw
