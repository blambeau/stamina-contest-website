module WebStamina
  module Controllers
    class PeopleController < ::Waw::ActionController

      # Login
      signature {
        validation :mail, mandatory & mail, :bad_user_or_password
        validation :password, (size>=8) & (size<=15), :bad_user_or_password
        #validation [:mail, :password], user_may_log, :bad_user_or_password
      }
      routing {
        upon 'validation-ko' do feedback end
        upon 'success/ok'    do refresh  end
      }
      def login(params)
        session_set(:user, params[:mail]) and :ok
      end
      
      signature {}
      def subscribe(params)
        :ok
      end
      
      # Login
      signature {
        validation :mail, mandatory & mail, :bad_email
        validation :message, mandatory, :missing_message
      }
      routing {
        upon 'validation-ko' do form_validation_feedback end
        upon 'success/ok'    do refresh  end
      }
      def contact(params)
        :ok
      end
      
    end # class PeopleController
  end # module Controllers
end # module WebStamina