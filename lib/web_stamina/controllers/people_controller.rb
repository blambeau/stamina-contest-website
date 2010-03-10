module WebStamina
  module Controllers
    class PeopleController < ::Waw::ActionController
      
      # Generates an activation key
      def generate_activation_key
        "%0#{128 / 4}x" % rand(2**128 - 1)
      end

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
      
      signature {
        validation [:mail, :nickname, :password, :password_confirm, :last_name, :first_name], mandatory, :registration_mandatory
        validation :mail, mail, :bad_mail
        validation :password, (size>=8) & (size<=15), :bad_password
        validation [:password, :password_confirm], (mandatory & same), :passwords_dont_match
        validation :authorize_submission_usage, (boolean | default(false)), :bad_authorize
      }
      routing {
        upon 'validation-ko' do form_validation_feedback end
        upon 'success/ok'    do refresh  end
      }
      def subscribe(params)
        resources.db.transaction do |t|
          t.default.people << params.keep(t.default.people.attribute_names).merge(:activation => generate_activation_key)
        end
        :ok
      end
      
      # Login
      signature {
        validation :mail, mandatory & mail, :bad_mail
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